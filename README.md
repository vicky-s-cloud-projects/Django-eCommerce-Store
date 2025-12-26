# 🚀 Production-Grade Django eCommerce 3-tier Application on AWS EKS (Zero-Trust Architecture)

## 📌 Project Overview

This repository showcases a production-grade Django eCommerce application deployed on AWS using Docker, Kubernetes (EKS) and managed entirely through Terraform Infrastructure as Code. All this process was done from local linux operating system.

The system is designed using zero-trust security principles, with no direct public access to application pods or databases. All traffic is routed securely through CloudFront and AWS WAF, then through a locked-down Application Load Balancer, into a private EKS cluster, and finally to Django application pods backed by Amazon RDS (PostgreSQL).

This project goes beyond a basic deployment and reflects real-world cloud engineering, including architecture design, security hardening, operational troubleshooting, and cost-aware lifecycle management.



## 🎯 What This Project Demonstrates

* End-to-end AWS cloud architecture design

* Kubernetes (EKS) deployment in private subnets

* Zero-trust networking and security model

* Dockerized Django application using Gunicorn

* CloudFront + AWS WAF as a secure public edge

* AWS Load Balancer Controller & Kubernetes Ingress

* Terraform-based modular infrastructure

* IAM least-privilege and IRSA concepts

* Real production troubleshooting (ALB, CloudFront, health checks)

* Clean teardown to avoid unnecessary AWS costs

This project intentionally includes real operational challenges such as ALB health check failures, CloudFront 502/400 errors, and security group misconfigurations to demonstrate hands-on problem-solving, not just a happy-path setup.


## 🧠 Architecture Overview
### High-Level Traffic Flow

User Browser

↓

CloudFront (Public CDN)

↓

AWS WAF (Web Application Firewall)

↓

Public Application Load Balancer (Restricted Access)

↓

Amazon EKS (Private Subnets)

↓

Kubernetes Service (ClusterIP)

↓

Django Pods (Gunicorn)

↓

Amazon RDS (PostgreSQL)

## 🖼️ Architecture Diagram

📌 PLACEHOLDER – Architecture Diagram

## 🛠️ Technology Stack
### Application Layer

  * Django (Python)

  * Gunicorn (WSGI Server)

### Containerization & Orchestration

  * Docker

  * Kubernetes

  * Amazon EKS

### Infrastructure as Code

  * Terraform (modular design)

### Networking & Security

  * Amazon VPC (public & private subnets)

  * Application Load Balancer (ALB)

  * AWS Load Balancer Controller

  * AWS CloudFront

  * AWS WAF

  * IAM & IRSA (IAM Roles for Service Accounts)

### Database

  * Amazon RDS (PostgreSQL)


## 🐳 Dockerized Django Application
The Django application is packaged into a Docker image and runs using Gunicorn as the production WSGI server.

  * Application listens on 0.0.0.0:8000

  * Environment variables used for configuration

  * No secrets are hardcoded inside the image

  * Image is designed for Kubernetes workloads
### Gunicorn Command
 ```
 gunicorn core.wsgi:application --bind 0.0.0.0:8000
 ```
## ☸️ Kubernetes Deployment (Amazon EKS)
### Key Design Decisions

  * All pods run in private subnets

  * Kubernetes Service type is ClusterIP

  * Ingress is managed by AWS Load Balancer Controller

  * Rolling deployments enabled

  * Horizontal scalability supported
 
### Resulting Security Model

  * No pod or service is publicly exposed

  * All ingress traffic flows through managed AWS services

  * Kubernetes cluster remains fully private

## ❤️ Health Check Design (Critical for ALB)
A dedicated health endpoint was implemented to satisfy Application Load Balancer health checks.
### Health Endpoint
```
 GET /healthz/ → HTTP 200 OK
```
This endpoint ensures:

  * ALB targets remain healthy

  * CloudFront can successfully reach the origin

  * No unexpected redirects or 400 errors break routing

Without this, CloudFront → ALB → EKS communication fails.

## 🔐 Zero-Trust Security Architecture
This project strictly follows zero-trust principles:

  * Kubernetes pods are never public

  * RDS is accessible only from EKS nodes

  * ALB security groups allow traffic only from CloudFront

  * CloudFront is the single public entry point

  * IAM roles follow least-privilege access

  * No implicit trust between components

## 🌍 CloudFront & AWS WAF
### CloudFront

  * Acts as the public CDN

  * Provides DDoS protection

  * Improves latency and availability

  * Serves as the secure edge layer

### AWS WAF

  * Attached directly to CloudFront

  * Protects against SQL injection, XSS, and malicious traffic

  * Adds an additional security layer before traffic reaches AWS infrastructure

## 🧩 Terraform Infrastructure
#### Terraform is used to provision and manage:

  * VPC & networking

  * Amazon EKS

  * Amazon RDS

  * CloudFront distribution

  * AWS WAF

  * IAM roles & policies

  * Security groups

#### Benefits

  * Fully reproducible infrastructure

  * Easy environment teardown

  * Clear separation of concerns using modules

  * Cost-aware cloud management

## 🚀 Deployment Workflow
1. Build & Push Docker Image
```
docker build -t django-ecommerce .
docker push <ECR_REPOSITORY>
```
2. Provision AWS Infrastructure
```
terraform init
terraform apply
```
3. Deploy Kubernetes Resources
```
kubectl apply -f k8s/
```
4. Access Application
  * Application is accessed via CloudFront domain
  * Backend remains protected behind ALB, WAF, and EKS

## 🧪 Troubleshooting & Validation Performed
This project involved real production debugging, including:
  * Fixing ALB target group health check failures
  * Resolving CloudFront '502 Failed to contact' origin errors
  * Correcting security group ingress rules
  * Validating Kubernetes pod networking
  * Debugging Django 'ALLOWED_HOSTS'
  * Verifying RDS connectivity and credentials

## 🖼️ Deployment Proof & Screenshots
* Terraform apply output
<img width="1920" height="1080" alt="Screenshot (11)" src="https://github.com/user-attachments/assets/359076de-c181-48cb-87d5-61e02cd4fad9" />

<img width="1920" height="1080" alt="Screenshot (12)" src="https://github.com/user-attachments/assets/789a28da-4e13-4f73-a8ee-0e19a8f94469" />

<img width="1920" height="1080" alt="Screenshot (13)" src="https://github.com/user-attachments/assets/2012371a-432f-41ef-9653-65922b260062" />

* EKS cluster status
<img width="1920" height="1031" alt="Screenshot (14)" src="https://github.com/user-attachments/assets/293357d8-1a4a-42f9-9da6-f3770c1fd4d9" />

<img width="1263" height="163" alt="Screenshot (19)" src="https://github.com/user-attachments/assets/e88ee250-5775-4c3e-b866-3724bc205592" />

* Kubernetes pods healthy
<img width="1920" height="1080" alt="Screenshot (16)" src="https://github.com/user-attachments/assets/e6c18172-0dbe-4c74-8a19-0e7abc1c220c" />

<img width="1352" height="225" alt="Screenshot (17)" src="https://github.com/user-attachments/assets/d692cc3b-a1ef-4ab3-85a8-646981f6b682" />

<img width="1920" height="591" alt="Screenshot (18)" src="https://github.com/user-attachments/assets/13e6e6ff-2a68-4d84-ae1d-24b90add5896" />

* ALB target group healthy
<img width="1920" height="1080" alt="Screenshot (21)" src="https://github.com/user-attachments/assets/4b07d067-a51a-406f-92aa-d4c9fc30c3d6" />

<img width="1920" height="141" alt="Screenshot (20)" src="https://github.com/user-attachments/assets/efa37bef-7928-4ceb-a416-d1f33776b089" />

<img width="1920" height="469" alt="Screenshot (28)" src="https://github.com/user-attachments/assets/4250d432-d2c1-47ab-821b-2ee875fb0200" />

<img width="1674" height="204" alt="Screenshot (31)" src="https://github.com/user-attachments/assets/e00ee74f-e41c-4a6a-8595-777422950fc1" />

<img width="1920" height="1080" alt="Screenshot (22)" src="https://github.com/user-attachments/assets/69aa24c3-2dc3-4671-a641-77f127f44343" />

<img width="1920" height="1080" alt="Screenshot (23)" src="https://github.com/user-attachments/assets/548de266-376c-4af3-9429-87c477bcf631" />

<img width="1920" height="1080" alt="Screenshot (26)" src="https://github.com/user-attachments/assets/38fb9bf8-dba0-4abb-a236-5645455adbb1" />

<img width="1920" height="1080" alt="Screenshot (27)" src="https://github.com/user-attachments/assets/7f46d721-cfdf-4fea-a846-efdb337b7d24" />

<img width="1920" height="986" alt="Screenshot (29)" src="https://github.com/user-attachments/assets/98eaded8-cdf6-442b-bc61-3fb5e6000a0b" />

<img width="1920" height="1002" alt="Screenshot (30)" src="https://github.com/user-attachments/assets/5545eda5-2294-4185-bb6e-a77df11c839c" />

<img width="1920" height="1080" alt="Screenshot (32)" src="https://github.com/user-attachments/assets/7a760191-34ce-4882-95d3-cb79492ae585" />

<img width="1920" height="1080" alt="Screenshot (33)" src="https://github.com/user-attachments/assets/260ccf5d-a402-4029-b3aa-3382f071fa2b" />

<img width="1920" height="1080" alt="Screenshot (34)" src="https://github.com/user-attachments/assets/c09b7163-e9a0-4a51-8b97-c2452c93e35f" />

<img width="1920" height="1080" alt="Screenshot (35)" src="https://github.com/user-attachments/assets/1852871b-c9e7-4b50-8803-6f1f058ce19b" />

<img width="1920" height="1080" alt="Screenshot (36)" src="https://github.com/user-attachments/assets/953c4d66-b2ab-4eb9-a433-cd91664d481a" />

<img width="1920" height="1080" alt="Screenshot (37)" src="https://github.com/user-attachments/assets/271288ea-78c6-436b-8d8e-8c2633750010" />


## 💰 Cost Management
All resources are provisioned using Terraform.
To avoid AWS charges, the entire infrastructure can be destroyed safely using:
```
terraform destroy
```
This removes:
* EKS cluster

* ALBs

* CloudFront

* WAF

* RDS

* VPC and networking components

## 👤 Author
Designed & deployed as part of cloud engineering learning and portfolio building.














 
