apiVersion: v1
kind: Service
metadata: 
  name: ${microservice_name}
  namespace: ${namespace}
  annotations:
    team.prometheus/path: /metrics
    team.prometheus/scrape: "true"
spec:
  selector:
    microservice: ${microservice_name}
  ports:
  - port: ${port}
    targetPort: ${port}
  type: ClusterIP