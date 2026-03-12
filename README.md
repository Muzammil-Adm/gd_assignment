1. Local environment (Minikube)
Single-node Minikube cluster running the classic voting app components: vote (UI), result (UI), worker, Redis, Postgres, each as K8s Deployments/Services.

NodePort or minikube service exposes vote and result to your browser on the VM/laptop.
​

Flow:

Browser → Minikube NodePort → vote pod → Redis → worker pod → Postgres → result pod → Browser.

2. Infrastructure layer (Terraform + LocalStack + AWS)
Terraform project (terraform/aws-eks) defines:

VPC, subnets, IGW, NAT.

EKS cluster (control plane + managed node group or Fargate).

RDS PostgreSQL (Multi‑AZ) and ElastiCache Redis in private subnets.

For local validation (no AWS bill), Terraform can target LocalStack endpoints for EKS/RDS/ElastiCache.
​

3. Application layer (Kubernetes / EKS)
One namespace (e.g. voting) with:

vote Deployment + Service (ClusterIP + ALB Ingress in prod).

result Deployment + Service.

worker Deployment (no Service).

redis Service → points to ElastiCache endpoint in prod.

db Service → points to RDS endpoint in prod.

Frontdoor:

Route53 voting.yourdomain.com → ALB (ingress) → vote and result services in EKS.

4. CI (GitHub Actions)
Workflow on push to main:

Checkout code.

Optionally build Docker images (if you decide to own images instead of using the sample ones).

Validate K8s manifests using kubeval or kubectl apply --dry-run=server against a cluster schema.

terraform init -backend=false && terraform validate for IaC linting.

No direct deployment from Actions → all changes go via GitOps.

5. CD (Argo CD GitOps)
Argo CD installed into the EKS cluster (or a separate “management” cluster).

Argo Application points at your Git repo and the k8s-specifications/ path:

source.repoURL = https://github.com/Muzammil-Adm/gd_assignment.git

source.path = k8s-specifications

destination.server = https://kubernetes.default.svc

destination.namespace = voting

syncPolicy.automated.prune.selfHeal = true.

Flow:

git push → GitHub Actions validates → ArgoCD notices repo change → syncs manifests to EKS → rolling update Deployments.


<img width="8192" height="3479" alt="Mermaid Chart - Create complex, visual diagrams with text -2026-03-12-151451" src="https://github.com/user-attachments/assets/90477882-8527-4f15-8ed1-e80bb2ba1ff6" />


