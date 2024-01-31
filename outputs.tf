
output "helm_release_id" {
  value       = helm_release.main.id
  description = "Helm Release ID"
}

output "helm_release_name" {
  value       = helm_release.main.name
  description = "Helm Release Name"
}

output "helm_release_namespace" {
  value       = helm_release.main.namespace
  description = "Helm Release Namespace"
}

output "helm_manifests_out" {
  value       = data.helm_template.main.manifests
  description = "Helm Release Manifest"
}