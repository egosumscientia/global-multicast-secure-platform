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
  project = "global-multicloud-secure-platform"
  region  = "us-central1"
  zone    = "us-central1-a"
}
