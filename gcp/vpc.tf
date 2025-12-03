resource "google_compute_network" "vpc" {
  name                    = "vpc-multicloud"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "subnet-main"
  network       = google_compute_network.vpc.id
  region        = var.region
  ip_cidr_range = cidrsubnet(var.gcp_cidr, 8, 1)
}
