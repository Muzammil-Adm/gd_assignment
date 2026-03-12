flowchart LR
  subgraph Dev["Developer & GitHub"]
    DevIDE["Dev VM/Laptop\nCode + k8s + Terraform"]
    Repo["GitHub Repo\n(k8s-specifications + terraform)"]
    CI["GitHub Actions CI\nkubeval + terraform validate"]
    DevIDE -->|"git push"| Repo
    Repo --> CI
  end

  subgraph GitOps["GitOps CD"]
    Argo["Argo CD\nApplication: voting-app"]
  end

  CI -->|"main updated"| Repo
  Repo -->|"poll/ webhook"| Argo

  subgraph Local["Local Environment"]
    MK["Minikube Cluster\nnamespace: voting"]
    MKVote["vote Deployment\n(NodePort/Ingress)"]
    MKResult["result Deployment"]
    MKWorker["worker Deployment"]
    MKRedis["Redis Service\n(ClusterIP)"]
    MKPG["Postgres Service\n(ClusterIP)"]
    MK --> MKVote
    MK --> MKResult
    MK --> MKWorker
    MKVote --> MKRedis
    MKWorker --> MKRedis
    MKWorker --> MKPG
    MKResult --> MKPG
  end

  subgraph AWS["AWS Production"]
    subgraph VPC["VPC (Public + Private Subnets)"]
      ALB["ALB + WAF\nIngress for EKS"]
      subgraph EKS["EKS Cluster\nnamespace: voting"]
        PVote["vote Deployment + Service"]
        PResult["result Deployment + Service"]
        PWorker["worker Deployment"]
        PRedis["Redis Service\n(ExternalName → ElastiCache)"]
        PPG["Postgres Service\n(ExternalName → RDS)"]
      end
      RDS["RDS PostgreSQL\nMulti-AZ"]
      Cache["ElastiCache Redis"]

      ALB --> PVote
      ALB --> PResult
      PVote --> PRedis
      PWorker --> PRedis
      PWorker --> PPG
      PResult --> PPG
      PRedis --> Cache
      PPG --> RDS
    end
  end

  subgraph IaC["IaC & AWS Mock"]
    TF["Terraform\n(VPC + EKS + RDS + ElastiCache)"]
    LS["LocalStack\nmock AWS endpoints"]
  end

  DevIDE --> TF
  TF -->|"plan/apply (local)"| LS
  TF -->|"plan/apply (prod)"| AWS
  Argo -->|"sync manifests"| Local
  Argo -->|"sync manifests"| AWS

