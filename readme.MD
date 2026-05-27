# Roboshop Microservices Deployment using Terraform on AWS

This project provisions a complete Roboshop microservices infrastructure on AWS using Terraform.

The infrastructure includes:

- Frontend Service
- Catalogue Service
- User Service
- Cart Service
- Shipping Service
- Payment Service
- MongoDB
- Redis
- MySQL
- RabbitMQ

---

# Architecture

```text
                    Internet
                        |
                        v
                  +-------------+
                  |  Frontend   |
                  |   NGINX     |
                  +-------------+
                    |    |    |
       -------------------------------------
       |         |         |        |      |
       v         v         v        v      v

 +-----------+ +--------+ +------+ +---------+ +---------+
 | Catalogue | | User   | | Cart | |Shipping | | Payment |
 +-----------+ +--------+ +------+ +---------+ +---------+
       |           |         |         |           |
       v           v         v         v           v

   MongoDB      MongoDB    Redis      MySQL     RabbitMQ
                    |
                  Redis
```

---

# Technologies Used

| Tool | Purpose |
|------|----------|
| Terraform | Infrastructure as Code |
| AWS EC2 | Compute Services |
| AWS Security Groups | Firewall Rules |
| Route53 | DNS Management |
| NGINX | Reverse Proxy |
| Linux | Operating System |

---

# Project Structure

```text
.
├── provider.tf
├── variables.tf
├── security-groups.tf
├── ec2-instance.tf
├── outputs.tf
├── route53.tf
├── scripts/
│   ├── frontend.sh
│   ├── mongodb.sh
│   ├── redis.sh
│   ├── mysql.sh
│   ├── rabbitmq.sh
│   ├── catalogue.sh
│   ├── user.sh
│   ├── cart.sh
│   ├── shipping.sh
│   └── payment.sh
└── └── dispatch.sh

```

---

# Prerequisites

Before starting, ensure you have:

- AWS Account
- IAM User with EC2 permissions
- Terraform Installed
- AWS CLI Configured

---

# Configure AWS CLI

```bash
aws configure
```

Provide:

```text
AWS Access Key
AWS Secret Key
Region
Output Format
```

---

# Initialize Terraform

```bash
terraform init
```

---

# Validate Terraform

```bash
terraform validate
```

---

# Terraform Plan

```bash
terraform plan
```

---

# Deploy Infrastructure

```bash
terraform apply -auto-approve
```

---

# Destroy Infrastructure

```bash
terraform destroy -auto-approve
```

---

# Frontend Access

After deployment:

```bash
terraform output
```

Example:

```text
frontend_public_ip = "54.xx.xx.xx"
```

Open browser:

```text
http://<frontend-public-ip>
```

---

# Security Groups

| Component | Port |
|------------|------|
| Frontend | 80 |
| Catalogue | 8080 |
| User | 8080 |
| Cart | 8080 |
| Shipping | 8080 |
| Payment | 8080 |
| MongoDB | 27017 |
| Redis | 6379 |
| MySQL | 3306 |
| RabbitMQ | 5672 |

---

# Features

- Terraform Automation
- Microservices Architecture
- NGINX Reverse Proxy
- EC2 Based Deployment
- Security Group Isolation
- Route53 DNS Integration
- User Data Bootstrapping
- Service Dependencies using `depends_on`

---

# User Data Debugging

Check cloud-init logs:

```bash
tail -100 /var/log/cloud-init-output.log
```

Check nginx:

```bash
systemctl status nginx
```

Check application:

```bash
curl localhost
```

---

# Common Issues

## EC2 vCPU Limit Exceeded

Error:

```text
VcpuLimitExceeded
```

Solution:

- Use Spot instances
- Reduce instance count
- Request quota increase

---

## NGINX Service Not Found

Solution:

```bash
dnf install nginx unzip curl -y
```

---

## Terraform Template Errors

Error:

```text
vars map does not contain key
```

Solution:

Ensure every variable used in shell scripts exists in `templatefile()`.

---

# Future Improvements

- Application Load Balancer
- Auto Scaling Groups
- HTTPS using ACM
- Private Subnets
- ECS/EKS Migration
- RDS & ElastiCache
- CI/CD Pipeline using GitHub Actions

---

# Author

Infrastructure built using:

- Terraform
- AWS
- Linux
- NGINX
- Roboshop Microservices
