output "vm_instance_name" {
  description = "Name of the VM instance"
  value       = module.gcp_infra.vm_instance_name
}

output "vm_instance_ip" {
  description = "Public IP address of the VM instance"
  value       = module.gcp_infra.vm_instance_ip
}

output "network_name" {
  description = "Name of the VPC network"
  value       = module.gcp_infra.network_name
}

output "firewall_name" {
  description = "Name of the firewall rule"
  value       = module.gcp_infra.firewall_name
}

output "bucket_name" {
  description = "Name of the GCS bucket"
  value       = google_storage_bucket.todo_app_bucket.name
}

output "bucket_url" {
  description = "URL of the GCS bucket"
  value       = google_storage_bucket.todo_app_bucket.url
}

output "service_account_email" {
  description = "Email of the service account"
  value       = google_service_account.todo_app_sa.email
}

output "application_url" {
  description = "URL to access the Todo application"
  value       = "http://${module.gcp_infra.vm_instance_ip}:8080"
}