apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    microservice: ${microservice_name}
  name: ${microservice_name}
  namespace: ${namespace}
spec:
  replicas: 1
  selector:
    matchLabels:
      microservice: ${microservice_name}
  strategy:
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 25%
    type: RollingUpdate
  template:
    metadata:
      labels:
        microservice: ${microservice_name}
    spec:
      containers:
      - env:
        %{~ for env in env_vars ~}
        - name: ${ env.name }
          value: "${ env.value }"
        %{~ endfor ~}
        image: ${image}
        imagePullPolicy: IfNotPresent
        name: ${microservice_name}
        resources:
          limits:
            cpu: ${cpu}
            memory: ${memory}
          requests:
            cpu: ${cpu}
            memory: ${memory}
      restartPolicy: Always
      serviceAccount: ${microservice_name}
      serviceAccountName: ${microservice_name}
      volumes:
      - configMap:
          defaultMode: 420
          name: configmap-${microservice_name}
        name: configmap-${microservice_name}