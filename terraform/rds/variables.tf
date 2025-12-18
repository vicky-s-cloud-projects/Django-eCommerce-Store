variable "vpc_id" {
  type = string
}

variable "database_subnets" {
  type = list(string)
}

variable "eks_node_sg_id" {
  type = string
}
