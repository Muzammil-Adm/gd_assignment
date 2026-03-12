# Example Voting App - K8s Assignment

Deploy the Docker [example-voting-app](https://github.com/dockersamples/example-voting-app) on local Kind cluster.

## 🎯 Demo URLs (after setup)
```
Vote App:     http://localhost:8080
Results App:  http://<VM-IP>:8081
```

## 📋 Prerequisites
- Debian 12 VM (4 CPU, 8GB RAM recommended)
- Root/sudo access

## 🚀 Quick Start (5 minutes)

### 1. Install Docker + Kind
```bash
# Download + run installer
curl -O https://raw.githubusercontent.com/YOUR-GIT-REPO/main/scripts/install-docker-kind.sh
chmod +x install-docker-kind.sh
sudo ./install-docker-kind.sh
```

**Logout and login again** (for docker group).

### 2. Create Kind cluster
```bash
cd Gd-Assignment
kind create cluster --config kind-config-simple.yaml --name voting-app
```

### 3. Deploy Voting App
```bash
cd example-voting-app/k8s-specifications/
kubectl apply -f .
```

### 4. Expose Apps
```bash
# Localhost access (port-forward)
kubectl port-forward svc/vote 8080:8080 --address 0.0.0.0 &
kubectl port-forward svc/result 8081:8081 --address 0.0.0.0 &

# External GCP VM IP access (NodePort)
kubectl get svc vote result  # Note NodePorts (31000, etc.)
```

**Browser**:
```
Local:    http://localhost:8080 (vote), http://localhost:8081 (results)
External: http://<GCP-IP>:8080 (vote)
```

## ✅ Verify deployment
```bash
kubectl get pods,svc
# All 5 pods: 1/1 Running
# vote/result services: NodePort with ports like 8080:31000/TCP
```

## 🛠️ Troubleshooting

| Issue | Solution |
|-------|----------|
| `port 8080 bind error` | `pkill -f kubectl` |
| Pods CrashLoopBackOff | `kubectl logs deployment/vote-deployment` |
| No service port 80 | Use actual port: `kubectl get svc vote` |
| External IP timeout | GCP Firewall: `tcp:31000` |

## 📁 Repo Structure
```
├── scripts/
│   └── install-docker-kind.sh     # Docker + Kind installer
├── kind-config-simple.yaml        # Kind cluster config
├── example-voting-app/            # Original app manifests
├── terraform/                     # EKS IaC (bonus)
├── helm-charts/                   # Helm version (bonus)
├── argocd/                       # GitOps (bonus)
└── docs/                         # Architecture diagram
```

## 🔧 Scripts

**install-docker-kind.sh** (Debian 12):
```bash
#!/bin/bash
# [Full script from previous response]
```

## 📊 Architecture

```
Browser → localhost:8080 → vote Service (8080:31000) → vote Pod
       → localhost:8081 → result Service → result Pod

Internal:
vote → redis → worker → postgres → result
```

**Production**: EKS + ALB + RDS/ElastiCache (see `terraform/`)

## 🎉 End-to-End Test
1. **Vote**: Click Cats 5x → http://localhost:8080
2. **Results**: See Cats % → http://localhost:8081  
3. **External**: http://<GCP-IP>:31000 from any browser

***
