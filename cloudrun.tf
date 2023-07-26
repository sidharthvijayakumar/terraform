resource "google_cloud_run_service" "hello" {
  name     = var.instance_name
  location = var.region
  project = var.project_id

  template {
    spec {
      containers {
        name= var.container_name
        ports {
            container_port= var.container_port
        }
        image = var.container_image
        env {
            name = "developer"
            value = "sidharth"
        }
        env {
            name = "env"
            value = "dev"
        }
        resources {
            limits = {
                cpu = var.container_cpu
                memory = var.container_memory
            }
        }
      }
      container_concurrency = var.container_concurrency
      timeout_seconds= var.container_timeout_seconds
      service_account_name= var.cloud_run_service_account
    }
  }
  traffic {
    percent         = 100
    latest_revision = true
  }
}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location    = google_cloud_run_service.hello.location
  project     = google_cloud_run_service.hello.project
  service     = google_cloud_run_service.hello.name

  policy_data = data.google_iam_policy.noauth.policy_data
}
