output "vm_instance_name" {
  description = "Name of the VM instance"
  value       = google_compute_instance.todo_app_vm.name
}

output "vm_instance_ip" {
  description = "Public IP address of the VM instance"
  value       = google_compute_instance.todo_app_vm.network_interface[0].access_config[0].nat_ip
}

output "network_name" {
  description = "Name of the VPC network"
  value       = google_compute_network.todo_app_network.name
}

output "firewall_name" {
  description = "Name of the firewall rule"
  value       = google_compute_firewall.todo_app_firewall.name
}