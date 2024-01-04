apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: ${microservice_name}
  namespace: ${namespace}
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: ${microservice_name}
  minReplicas: ${minReplicas}
  maxReplicas: ${maxReplicas}
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: ${averageCPUUtilization}
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: ${averageMemoryUtilization}
