variable "microservice_name" {
  type = string
}

variable "port" {
  type = number
}

variable "account_id" {
  type = string
}

variable "region" {
  type = string
}

variable "keycloakUrl" {
  type = string
}

variable "eks_oidc_id" {
  type = string
  
}

variable "cluster_name" {
  type = string
}

variable "namespace" {
  type = string
}

variable "env_vars" {
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "minReplicas" {
  type = number
}

variable "maxReplicas" {
  type = number
}

variable "averageCPUUtilization" {
  type = number
}

variable "averageMemoryUtilization" {
  type = number
}

variable "image" {
  type = string
}

variable "cpu" {
  type = string
}

variable "memory" {
  type = string
}

variable "ingresses" {
  type = list(object({
    domain = string
    ingress_name = string
    endpoints = list(string)
  }))
  default = []
}

variable "cluster_ca_certificate" {
  type = string
}

variable "cluster_endpoint" {
  type = string
}

variable "aws_role_arn" {
  type = string
}

variable "aws_role_name" {
  type = string
}