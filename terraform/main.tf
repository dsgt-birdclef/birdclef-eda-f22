terraform {
  backend "gcs" {
    bucket = "birdclef-eda-f22-tfstate"
    prefix = "birdclef-eda-f22-public"
  }
}

locals {
  project_id = "birdclef-eda-f22"
  region     = "us-central1"
}

provider "google" {
  project = local.project_id
  region  = local.region
}

resource "google_project_service" "service" {
  for_each = toset(["artifactregistry"])
  service  = "${each.key}.googleapis.com"
}

resource "google_artifact_registry_repository" "birdclef-eda-f22" {
  location      = "us-central1"
  repository_id = "birdclef-eda-f22"
  format        = "DOCKER"
  depends_on    = [google_project_service.service["artifactregistry"]]
}

resource "google_storage_bucket" "birdclef-eda-f22" {
  name     = local.project_id
  location = "US"
  versioning {
    enabled = true
  }
  lifecycle_rule {
    condition {
      num_newer_versions = 3
    }
    action {
      type = "Delete"
    }
  }
  cors {
    origin          = ["*"]
    method          = ["GET"]
    response_header = ["*"]
    max_age_seconds = 3600
  }
}


resource "google_storage_bucket_iam_binding" "default-public" {
  bucket = google_storage_bucket.birdclef-eda-f22.name
  role   = "roles/storage.objectViewer"
  members = [
    "allUsers"
  ]
}


output "bucket_name" {
  value = google_storage_bucket.birdclef-eda-f22.name
}
