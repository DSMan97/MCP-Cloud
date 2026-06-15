resource "null_resource" "docker_push" {
  count = fileexists("${path.module}/Dockerfile") ? 1 : 0
  triggers = {
    dockerfile = md5(file("${path.module}/Dockerfile"))
    index      = fileexists("${path.module}/index.html") ? md5(file("${path.module}/index.html")) : ""
  }

  provisioner "local-exec" {
    command = <<EOT
      gcloud auth configure-docker ${split("/", var.image_url)[0]} --quiet
      docker build -t ${var.image_url} -f ${path.module}/Dockerfile ${path.module}
      docker push ${var.image_url}
    EOT
  }
}

resource "google_cloud_run_v2_service" "mcp_service" {
  name     = var.service_name
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    service_account = var.service_account_email
    containers {
      image = var.image_url
      env {
        name  = "GOOGLE_CLOUD_PROJECT"
        value = var.project_id
      }
      ports {
        container_port = 8080
      }
      resources {
        limits = {
          cpu    = var.cpu
          memory = var.memory
        }
      }
    }
    timeout = "300s"
  }

  depends_on = [null_resource.docker_push]
}

