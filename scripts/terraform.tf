provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_storage_bucket" "model_bucket" {
  name = var.model_bucket_name
}

resource "google_cloudfunctions_function" "predict_function" {
  name        = var.function_name
  description = "API for predicting flight delays"
  runtime     = "python37"
  trigger_http = true

  source_archive_bucket = google_storage_bucket.model_bucket.name
  source_archive_object = "app.zip"
  entry_point           = "predict"

  environment_variables = {
    "MODEL_BUCKET_NAME" = var.model_bucket_name
    "MODEL_FILE_NAME"   = var.model_file_name
  }
}

resource "google_pubsub_topic" "cloud_build_topic" {
  name = "cloud-builds"
}

resource "google_pubsub_subscription" "cloud_build_subscription" {
  name = "cloud-build-subscription"
  topic = google_pubsub_topic.cloud_build_topic.name
}

resource "google_cloud_build_trigger" "build_trigger" {
  name = "build-trigger"
  description = "Trigger a Cloud Build when new code is pushed to GitHub"
  github {
    owner = var.github_owner
    name = var.github_repo
    push {
      branch = var.github_branch
    }
  }
  substitutions = {
    "_REGION"           = var.region
    "_PROJECT_ID"       = var.project_id
    "_FUNCTION_NAME"    = var.function_name
    "_MODEL_BUCKET_NAME" = var.model_bucket_name
    "_MODEL_FILE_NAME"  = var.model_file_name
  }
  filename = "cloudbuild.yaml"
}
