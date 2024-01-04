apiVersion: v1
kind: ServiceAccount
metadata:
  name: ${microservice_name}
  namespace: ${namespace}
  annotations:
    "eks.amazonaws.com/role-arn": "arn:aws:iam::${account_id}:role/${microservice_name}-role"