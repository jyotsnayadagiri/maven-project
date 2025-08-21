output "vm_instance_name" {
  description = "Name of the VM instance"
  value       = google_compute_instance.vm.name
}

output "vm_instance_ip" {
  description = "Public IP address of the VM instance"
  value       = google_compute_instance.vm.network_interface[0].access_config[0].nat_ip
}

output "firewall_http_name" {
  description = "Name of the HTTP firewall rule"
  value       = google_compute_firewall.allow_http.name
}

output "firewall_ssh_name" {
  description = "Name of the SSH firewall rule"
  value       = google_compute_firewall.allow_ssh.name
}
