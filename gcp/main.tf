terraform {
  required_version = ">= 1.6.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

provider "google" {
  project = "gcp-multicloud-secure"
  region  = "us-central1"
  zone    = "us-central1-a"
}
