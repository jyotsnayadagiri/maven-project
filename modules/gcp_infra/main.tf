# Create a service account for provisioner
resource "google_service_account" "provisioner_sa" {
  account_id   = "provisioner-sa"
  display_name = "Service Account for Provisioner"
}

# Create a VPC network
resource "google_compute_network" "todo_app_network" {
  name                    = var.network_name
  auto_create_subnetworks = true
}

# Create a firewall rule
resource "google_compute_firewall" "todo_app_firewall" {
  name    = "${var.network_name}-firewall"
  network = google_compute_network.todo_app_network.name

  allow {
    protocol = "tcp"
    ports    = var.firewall_ports
  }

  source_ranges = ["0.0.0.0/0"]
}

# Create a VM instance
resource "google_compute_instance" "todo_app_vm" {
  name         = var.vm_name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    network = google_compute_network.todo_app_network.name
    access_config {
      // Ephemeral public IP
    }
  }

  service_account {
    email  = google_service_account.provisioner_sa.email
    scopes = ["cloud-platform"]
  }

  metadata = {
    enable-oslogin = "TRUE"
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y docker.io
    systemctl start docker
    systemctl enable docker
    docker run -d -p 8080:8080 --name todo-app your-jfrog-repo/todo-app:latest
  EOF

  tags = ["http-server", "ssh"]
}