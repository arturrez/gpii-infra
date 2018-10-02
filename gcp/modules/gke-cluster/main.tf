terraform {
  backend "gcs" {}
}

variable "env" {}
variable "project_id" {}
variable "serviceaccount_key" {}

module "gke_cluster" {
  source             = "/exekube-modules/gke-cluster"
  project_id         = "${var.project_id}"
  serviceaccount_key = "${var.serviceaccount_key}"

  initial_node_count = 1
  node_type          = "${var.env == "dev" ? "n1-standard-2" : "n1-highcpu-4"}"
  kubernetes_version = "1.10.7-gke.2"

  main_compute_zone  = "us-central1-a"
  additional_zones   = ["us-central1-b", "us-central1-c"]

  monitoring_service = "monitoring.googleapis.com/kubernetes"
  logging_service    = "logging.googleapis.com/kubernetes"

  oauth_scopes = [
    "https://www.googleapis.com/auth/compute",
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring",
  ]

  dashboard_disabled = true

  update_timeout = "30m"
}
