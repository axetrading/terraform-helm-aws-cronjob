variable "atomic" {
  type        = bool
  description = "If set, the installation process purges the chart on failure. The wait flag will be set automatically if atomic is used."
  default     = false
}

variable "name" {
  type        = string
  description = "The name of the Helm deployment."
}

variable "namespace" {
  type        = string
  description = "The namespace to install the release into."
  default     = "default"
}

variable "timeout" {
  type        = number
  description = "The time, in seconds, that Terraform will wait for a Helm release to create resources."
  default     = 150
}

variable "wait" {
  type        = bool
  description = "If set, Terraform will wait for the Helm release to complete before continuing."
  default     = true
}


variable "create_role" {
  description = "Whether to create a role"
  type        = bool
  default     = true
}

variable "role_name" {
  description = "Name of IAM role"
  type        = string
  default     = null
}

variable "role_path" {
  description = "Path of IAM role"
  type        = string
  default     = "/"
}

variable "role_permissions_boundary_arn" {
  description = "Permissions boundary ARN to use for IAM role"
  type        = string
  default     = null
}

variable "role_description" {
  description = "IAM Role description"
  type        = string
  default     = null
}

variable "role_name_prefix" {
  description = "IAM role name prefix"
  type        = string
  default     = null
}

variable "policy_name_prefix" {
  description = "IAM policy name prefix"
  type        = string
  default     = "eks-policy"
}

variable "role_policy_arns" {
  description = "ARNs of any policies to attach to the IAM role"
  type        = set(string)
  default     = []
}

variable "oidc_providers" {
  description = "Map of OIDC providers where each provider map should contain the `provider`, `provider_arn`, and `namespace_service_accounts`"
  type        = any
  default     = {}
}

variable "tags" {
  description = "A map of tags to add the the IAM role"
  type        = map(any)
  default     = {}
}

variable "force_detach_policies" {
  description = "Whether policies should be detached from this role when destroying"
  type        = bool
  default     = true
}

variable "max_session_duration" {
  description = "Maximum CLI/API session duration in seconds between 3600 and 43200"
  type        = number
  default     = null
}

variable "assume_role_condition_test" {
  description = "Name of the [IAM condition operator](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements_condition_operators.html) to evaluate when assuming the role"
  type        = string
  default     = "StringEquals"
}

variable "attach_secrets_policy" {
  type        = bool
  description = "Attach a policy that will allow the role to get secrets from AWS Secrets Manager or AWS SSM"
  default     = true
}

variable "additional_value_files" {
  type        = list(any)
  description = "A list of additional value files. It will work in the same way as helm -f value1.yaml -f value2.yaml"
  default     = []
}

variable "role_arn" {
  type        = string
  description = "Existing role ARN"
  default     = null
}

variable "image_repository" {
  type        = string
  description = "Kubernetes Deployment image for pod's container"
}

variable "image_pull_policy" {
  type        = string
  description = "The imagePullPolicy for a container and the tag of the image affect when the kubelet attempts to pull (download) the specified image."
  default     = "IfNotPresent"
}

variable "secrets" {
  type        = list(any)
  description = "A list of AWS Secret Manager Secrets that will be mounted as volumes on your containers"
  default     = null
}


variable "resources" {
  type = object({
    memory = string
    cpu    = string
  })
  default = {
    cpu    = "250m"
    memory = "512Mi"
  }
  description = <<EOT
  "A map of resource for the main app container, containing keys 'cpu' and 'memory'. 
  This is following the Kubernetes resource best practices, which states that no limits for the CPU should be set and the memory limit should always be equal with memory request.
  In this way, we can prevent OOMKill (talk with the devs about cpu/memory requirements)."
  EOT
}



variable "persistence_enabled" {
  type        = bool
  description = "Whether to create persistent storage"
  default     = false
}

variable "persistence_accessMode" {
  type        = string
  description = "Accessmode for persistent storage"
  default     = "ReadWriteOnce"
}

variable "persistence_storageSize" {
  type        = string
  description = "Storage size for persistent storage"
  default     = "2Gi"
}

variable "persistence_mountPath" {
  type        = string
  description = "Mount Path for Persistent Storage on Pod"
  default     = ""
}


variable "attach_amazoneks_efs_csi_driver_policy" {
  type        = bool
  description = "Attach a policy that allows the CSI driver’s service account to make calls to AWS APIs on your behalf"
  default     = false
}

variable "storage_class_name" {
  type        = string
  description = "Name of the storage class"
  default     = "efs-sc"
}


variable "cron_job_commands" {
  type        = list(any)
  description = "Commands for cron job"
  default     = []
}

variable "cron_job_schedule" {
  type        = string
  description = "The cron job schedule which follow https://en.wikipedia.org/wiki/Cron"
  default     = ""
}

variable "cron_job_image_tag" {
  type        = string
  description = "Kubernetes Cron job image tag"
}

variable "create_service_account" {
  type        = bool
  description = "Whether to create a service account for Kubernetes Deployment"
  default     = true
}

