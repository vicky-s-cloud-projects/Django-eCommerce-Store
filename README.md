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

 
