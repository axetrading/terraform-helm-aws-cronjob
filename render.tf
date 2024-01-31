data "helm_template" "main" {
  name             = var.name
  chart            = "${path.module}/helm/axetrading-cronjob"
  atomic           = var.atomic
  create_namespace = var.create_namespace
  namespace        = var.namespace
  timeout          = var.timeout
  wait             = var.wait

  values = local.deployment_values

  set {
    name  = "podAnnotations.cluster-autoscaler\\.kubernetes\\.io/safe-to-evict"
    value = var.safe_to_evict_enabled
    type  = "string"
  }

  dynamic "set" {
    for_each = var.create_role && var.create_service_account ? [aws_iam_role.this[0].arn] : [var.role_arn]
    content {
      name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = set.value
      type  = "string"
    }
  }

  set {
    name  = "image.repository"
    value = var.image_repository
    type  = "string"
  }

  set {
    name  = "image.tag"
    value = var.cron_job_image_tag
    type  = "string"
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
    name  = "container_commands.args"
    value = "{${join(",", var.container_commands_args)}}"
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

  dynamic "set" {
    for_each = var.persistence_enabled ? [var.persistence_enabled] : []
    content {
      name  = "efsProvisioner.efsFileSystemId"
      value = var.efs_filesystem_id
      type  = "string"
    }
  }

  dynamic "set" {
    for_each = var.ingress_enabled ? [var.ingress_enabled] : []
    content {
      name  = "ingress.annotations.kubernetes\\.io/ingress\\.class"
      value = "nginx"
      type  = "string"
    }
  }

  dynamic "set" {
    for_each = var.create_storage_class ? [true] : [false]
    content {
      name  = "storageClass.create"
      value = set.value
    }
  }

  dynamic "set" {
    for_each = var.persistence_enabled ? [var.persistence_enabled] : []
    content {
      name  = "persistence.storageClassName"
      value = var.storage_class_name
    }
  }

}