resource "kubectl_manifest" "namespace" {
  yaml_body = templatefile("${path.module}/templates/namespace.tpl", {
    namespace         = var.namespace
  })
}

resource "kubectl_manifest" "deployment" {
  yaml_body = templatefile("${path.module}/templates/deployment.tpl", {
    microservice_name = var.microservice_name
    port              = var.port
    image             = var.image
    namespace         = var.namespace
    env_vars          = var.env_vars
    cpu               = var.cpu
    memory            = var.memory
    account_id        = var.account_id
    region            = var.region
    keycloakUrl       = var.keycloakUrl   
  })

  depends_on = [
    kubectl_manifest.configmap,
    kubectl_manifest.serviceaccount,
    kubectl_manifest.namespace
  ]
}

resource "kubectl_manifest" "service" {
  yaml_body = templatefile("${path.module}/templates/service.tpl", {
    microservice_name = var.microservice_name
    namespace         = var.namespace
    port              = var.port
  })
  depends_on = [
    kubectl_manifest.namespace
  ]
}

resource "kubectl_manifest" "serviceaccount" {
  yaml_body = templatefile("${path.module}/templates/serviceaccount.tpl", {
    microservice_name = var.microservice_name
    namespace         = var.namespace
    account_id        = var.account_id  
  })

  depends_on = [
    aws_iam_role.microservice_role,
    aws_iam_role_policy_attachment.microservice_opa_policy
  ]
}

resource "kubectl_manifest" "hpa" {
  yaml_body = templatefile("${path.module}/templates/hpa.tpl", {
    microservice_name        = var.microservice_name
    namespace                = var.namespace
    minReplicas              = var.minReplicas
    maxReplicas              = var.maxReplicas
    averageCPUUtilization    = var.averageCPUUtilization
    averageMemoryUtilization = var.averageMemoryUtilization
  })

  depends_on = [
    kubectl_manifest.namespace,
    kubectl_manifest.deployment
  ]
}

resource "kubectl_manifest" "configmap" {
  yaml_body = templatefile("${path.module}/templates/envoy_configmap.tpl", {
    microservice_name = var.microservice_name
    namespace         = var.namespace
    port              = var.port
  })
  depends_on = [
    kubectl_manifest.namespace
  ]
}

resource "kubectl_manifest" "ingress" {
  count = length(var.ingresses)
  yaml_body = templatefile("${path.module}/templates/ingress.tpl", {
    microservice_name = var.microservice_name
    namespace         = var.namespace
    port              = var.port
    ingress_name      = var.ingresses[count.index].ingress_name
    domain            = var.ingresses[count.index].domain
    endpoints         = var.ingresses[count.index].endpoints
  })
  depends_on = [
    kubectl_manifest.namespace
  ]
}