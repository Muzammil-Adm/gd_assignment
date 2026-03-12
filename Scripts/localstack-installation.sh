#!/bin/bash
set -e

echo "☁️ LocalStack (AWS Local) Starter"

mkdir -p ~/localstack

cat > ~/localstack/docker-compose.yml << 'EOF'
version: '3.8'
services:
  localstack:
    image: localstack/localstack:latest
    ports:
      - "4566:4566"
    environment:
      - SERVICES=s3,eks,rds,elasticache,iam,route53,ec2,elb
      - DEBUG=1
      - DATA_DIR=/tmp/localstack/data
      - DEFAULT_REGION=us-east-1
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock"
EOF

docker compose -f ~/localstack/docker-compose.yml up -d

# Wait + test
sleep 10
curl -s http://localhost:4566/health | grep '"services":"[^"]*"'

echo "✅ LocalStack running → http://localhost:4566/health"
echo "AWS CLI: export AWS_ENDPOINT_URL=http://localhost:4566"
echo "Terraform: endpoint_url = \"http://localhost:4566\""

