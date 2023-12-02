provider "google" {
  credentials = file("/Users/sidharth/Downloads/corded-dragon-404510-394085e5aa12.json")
  project     = var.project_id
  region      = "us-central1" # Replace with your desired region
}

resource "google_compute_global_address" "lb_ip" {
  name                  = "lb-ip"
  project               = var.project_id
  purpose               = var.purpose_ip
  address_type          = var.address_type
}

resource "google_compute_ssl_certificate" "lb_ssl_certificate" {
  name        = var.ssl_certificate_name
  description = "SSL certificate for load balancer"
  project     = var.project_id
  private_key = file(var.private_key_path)
  certificate = file(var.ca_cert_path)
}

resource "google_compute_http_health_check" "lb_http_health_check" {
  name               = "lb-http-health-check"
  project            = var.project_id
  request_path       = "/incomes"
  port               = 80
  check_interval_sec = 60
  timeout_sec        = 60
  healthy_threshold  = 2
  unhealthy_threshold = 10
}

resource "google_compute_backend_service" "lb_backend_service" {
  name                    = "lb-backend-service"
  project                 = var.project_id
  protocol                = "HTTP"
  timeout_sec             = 300
  enable_cdn              = true
  port_name               = "http"
  backend {
    group = "https://www.googleapis.com/compute/v1/projects/corded-dragon-404510/zones/us-central1-c/instanceGroups/instance-group-1" # Replace with the backend instance group
  }
  health_checks = [
    google_compute_http_health_check.lb_http_health_check.self_link
  ]
}

resource "google_compute_url_map" "lb_url_map" {
  name            = "https-load-balancer"
  project         = var.project_id
  default_service = google_compute_backend_service.lb_backend_service.self_link
}

resource "google_compute_target_https_proxy" "lb_target_proxy" {
  name             = "lb-target-proxy"
  project          = var.project_id
  url_map          = google_compute_url_map.lb_url_map.self_link
  ssl_certificates = [google_compute_ssl_certificate.lb_ssl_certificate.id]
}

resource "google_compute_global_forwarding_rule" "lb_forwarding_rule" {
  name       = "lb-forwarding-rule"
  project    = var.project_id
  target     = google_compute_target_https_proxy.lb_target_proxy.self_link
  port_range = 443
  ip_address = google_compute_global_address.lb_ip.address
}
resource "google_compute_url_map" "http-redirect" {
  name = "http-redirect"

  default_url_redirect {
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"  // 301 redirect
    strip_query            = false
    https_redirect         = true  // this is the magic
  }
}

resource "google_compute_target_http_proxy" "http-redirect" {
  name    = "http-redirect"
  url_map = google_compute_url_map.http-redirect.self_link
}
resource "google_compute_target_http_proxy" "lb_target_proxy" {
  name             = "lb-target-proxy"
  project          = var.project_id
  url_map          = google_compute_url_map.lb_url_map.self_link
}
resource "google_compute_global_forwarding_rule" "http_to_static_pages" {
  name       = "http-products-forward-rule"
  target     = google_compute_target_http_proxy.lb_target_proxy.self_link
  ip_address = google_compute_global_address.lb_ip.address
  port_range = "80"
}