apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    kubernetes.io/ingress.class: nginx
  name: ${ingress_name}
  namespace: ${namespace}
spec:
  rules:
  - host: ${domain}
    http:
      paths:
      %{~ for ep in endpoints ~}
      - backend:
          service:
            name: ${microservice_name}
            port:
              number: ${port}
        path: ${ep}
        pathType: Prefix
      %{~ endfor ~}
