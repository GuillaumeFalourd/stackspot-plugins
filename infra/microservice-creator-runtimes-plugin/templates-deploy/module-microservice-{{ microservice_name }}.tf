module "microservice_{{ microservice_name }}" {

  source = "./microserviceapp-tf"

  aws_role_arn  =  module.microservice_{{ microservice_name }}.aws_role_arn
  aws_role_name =  module.microservice_{{ microservice_name }}.aws_role_name

  {% if environment == "Sandbox" %}
  keycloakUrl              = "https://idm.orgs.sbox.stackspot.com"
  {% elif environment == "QA" %}
  keycloakUrl              = "https://idm.qa.stackspot.com"
  {% else %}
  keycloakUrl              = "https://idm.stackspot.com"
  {% endif %}  
  microservice_name        = "{{ microservice_name }}"
  image                    = "{{ inputs.image }}"
  port                     = {{ inputs.port }}
  eks_oidc_id              = "{{connections["eks"].eks_oidc_id}}"
  account_id               = "{{connections["eks"].account_id}}"
  region                   = "{{connections["eks"].region}}"
  cluster_endpoint         = "{{connections["eks"].cluster_endpoint}}"
  cluster_ca_certificate   = "{{connections["eks"].cluster_ca_certificate}}"
  cluster_name             = "{{connections["eks"].cluster_name}}"
  namespace                = "{{ microservice_name }}"
  cpu                      = "{{ inputs.cpu }}"
  memory                   = "{{ inputs.memory }}"
  minReplicas              = {{ inputs.min_replicas }}
  maxReplicas              = {{ inputs.max_replicas }}
  averageCPUUtilization    = {{ inputs.average_memory_utilization }}
  averageMemoryUtilization = {{ inputs.average_cpu_utilization }}
  {% if inputs.check_ingress == true %}
  ingresses                = [
    {
      domain        = "{{ microservice_name }}.{{ inputs.domain}}"
      ingress_name  = "{{ microservice_name }}"
      endpoints     = [ "{{ inputs.endpoint }}" ]
    } 
  ]
  {% endif %}
}
