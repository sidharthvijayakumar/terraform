resource "google_vpc_access_connector" "vpc_connector" {
  name  = "vpc-connector-test"
  project = "angelic-hexagon-307814"
  region        = "us-central1"
  subnet {
    name = google_compute_subnetwork.custom_test.name
  }
  machine_type = "f1-micro"
  min_instances = 2
  max_instances = 3
}

resource "google_compute_subnetwork" "custom_test" {
  name          = "vpc-con"
  ip_cidr_range = "10.2.0.0/28"
  region        = "us-central1"
  network       = google_compute_network.custom_test.id
}

resource "google_compute_network" "custom_test" {
  name                    = "vpc-con"
  auto_create_subnetworks = false
}