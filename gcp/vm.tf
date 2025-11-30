resource "google_compute_address" "public_ip" {
  name = "gcp-public-ip"
}

resource "google_compute_instance" "vm" {
  name         = "gcp-multicloud-vm"
  machine_type = "e2-micro"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/ubuntu-2204-jammy-v20240114"
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
