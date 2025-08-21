# Configure the Google Cloud provider
provider "google" {
  project = "harness-466107"  # Replace with your GCP project ID
  region  = "us-east1"
  zone    = "us-east1-b"
}

# Data source to fetch information about your existing bucket
data "google_storage_bucket" "jyotsna_bucket" {
  name = "jyotsna-bucket-2"
}

# Create a VPC network
resource "google_compute_network" "provisioner_demo_vpc" {
  name                    = "provisioner-demo-vpc"
  auto_create_subnetworks = false
}

# Create a subnet
resource "google_compute_subnetwork" "provisioner_demo_subnet" {
  name          = "provisioner-demo-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = "us-east1"
  network       = google_compute_network.provisioner_demo_vpc.id
}

# Create a firewall rule to allow SSH
resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.provisioner_demo_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]  # Warning: In production, restrict this to your IP
}

# Create a service account for the VM
resource "google_service_account" "provisioner_sa" {
  account_id   = "provisioner-sa"
  display_name = "Provisioner Demo Service Account"
}

# Create a Google Compute Engine instance
resource "google_compute_instance" "provisioner_demo" {
  name         = "provisioner-demo-vm"
  machine_type = "e2-micro"
  zone         = "us-east1-b"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network    = google_compute_network.provisioner_demo_vpc.name
    subnetwork = google_compute_subnetwork.provisioner_demo_subnet.name
    access_config {} # External IP
  }

  service_account {
    email  = google_service_account.provisioner_sa.email
    scopes = ["cloud-platform"]
  }

  # Startup script instead of SSH provisioners
  metadata_startup_script = <<-EOF
    #!/bin/bash
    echo "Starting provisioning at $(date)" > /tmp/provision.log
    sudo apt-get update
    sudo apt-get install -y nginx
    sudo systemctl start nginx
    echo "Nginx installed and started" >> /tmp/provision.log
    echo "Connected to bucket: ${data.google_storage_bucket.jyotsna_bucket.name}" >> /tmp/provision.log
    echo "Provisioning completed at $(date)" >> /tmp/provision.log
  EOF

  provisioner "local-exec" {
    command = "echo 'VM ${self.name} created at $(date)' >> provisioner_log.txt"
  }
}

# Output the VM's public IP address
output "vm_public_ip" {
  value = google_compute_instance.provisioner_demo.network_interface[0].access_config[0].nat_ip
}

# Output the SSH command
output "ssh_command" {
  value = "ssh -i ~/.ssh/id_rsa ubuntu@${google_compute_instance.provisioner_demo.network_interface[0].access_config[0].nat_ip}"
}

# Output information about the existing bucket
output "existing_bucket_info" {
  value = {
    name = data.google_storage_bucket.jyotsna_bucket.name
    location = data.google_storage_bucket.jyotsna_bucket.location
    storage_class = data.google_storage_bucket.jyotsna_bucket.storage_class
    self_link = data.google_storage_bucket.jyotsna_bucket.self_link
  }
  description = "Information about the existing GCS bucket"
}
