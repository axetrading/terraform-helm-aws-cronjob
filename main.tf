
locals {
  values = [
    templatefile("${path.module}/helm/axetrading-cronjob/values.yaml.tpl", {
      imagePullPolicy  = var.image_pull_policy
      awsSecrets       = var.secrets
      fullNameOverride = var.name
      resources        = var.resources
      cronJobCommands  = var.cron_job_commands
      cronJobSchedule  = var.cron_job_schedule
      }
    )
  ]
  deployment_values = compact(local.values)
}
resource "helm_release" "main" {
  name      = var.name
  chart     = "${path.module}/helm/axetrading-cronjob"
  atomic    = var.atomic
  namespace = var.namespace
  timeout   = var.timeout
  wait      = var.wait

  values = local.deployment_values


  set {
    name  = "cronJob.args"
    value = "{${join(",", var.cron_job_commands)}}"
  }


  set {
    name  = "persistence.enabled"
    value = var.persistence_enabled
  }

  set {
    name  = "persistence.accessMode"
    value = var.persistence_accessMode
    type  = "string"
  }

  set {
    name  = "persistence.storageSize"
    value = var.persistence_storageSize
    type  = "string"
  }

  set {
    name  = "persistence.mountPath"
    value = var.persistence_mountPath
    type  = "string"
  }

  set {
    name  = "image.tag"
    value = var.cron_job_image_tag
    type  = "string"
  }

    set {
    name  = "image.repository"
    value = var.image_repository
    type  = "string"
  }

  dynamic "set" {
    for_each = var.persistence_enabled ? [var.persistence_enabled] : []
    content {
      name  = "persistence.storageClassName"
      value = var.storage_class_name
    }
  }

}