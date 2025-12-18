variable "aws_region" {
  description = "Primary AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name prefix"
  type        = string
  default     = "django-eks"
}

variable "internal_alb_dns_name" {
  description = "Internal ALB DNS name created by EKS ingress"
  type        = string
}
