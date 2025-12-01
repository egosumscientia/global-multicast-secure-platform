resource "google_compute_address" "public_ip" {
  name = "gcp-public-ip"
}

resource "google_compute_instance" "vm" {
  name         = "gcp-multicloud-vm"
  machine_type = "e2-micro"
  zone         = var.zone

  tags = ["multicloud-vm"]  # TAG necesario para firewall

  boot_disk {
    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/family/ubuntu-2204-lts"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.id

    access_config {
      nat_ip = google_compute_address.public_ip.address
    }
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/multicloud.pub")}"
  }
}

# Firewall para SSH e ICMP
resource "google_compute_firewall" "vm_fw" {
  name    = "fw-multicloud-vm"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["186.114.59.232/32"]
  target_tags   = ["multicloud-vm"]
}
