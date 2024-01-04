output "aws_role_arn" {
  value = module.microservice_{{ microservice_name }}.aws_role_arn
}

output "aws_role_name" {
  value = module.microservice_{{ microservice_name }}.aws_role_name
}