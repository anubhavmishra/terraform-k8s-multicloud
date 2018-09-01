locals {
  service_account_path = "${path.module}/service-account.yaml"
}

provider "google" {
  project = "${var.gke_project}"
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "google_container_cluster" "cluster" {
  name               = "consul-k8s-${random_id.suffix.dec}"
  project            = "${var.gke_project}"
  enable_legacy_abac = true
  initial_node_count = 5
  zone               = "${var.gke_zone}"
  min_master_version = "${var.gke_k8s_version}"
  node_version       = "${var.gke_k8s_version}"
}

resource "null_resource" "kubectl" {
  count = "${var.gke_init_cli ? 1 : 0 }"

  triggers {
    cluster = "${google_container_cluster.cluster.id}"
  }

  # On destroy we want to try to clean up the kubectl credentials. This
  # might fail if the credentials are already cleaned up or something so we
  # want this to continue on failure. Generally, this works just fine since
  # it only operates on local data.
  provisioner "local-exec" {
    when       = "destroy"
    on_failure = "continue"
    command    = "kubectl config get-clusters | grep ${google_container_cluster.cluster.name} | xargs -n1 kubectl config delete-cluster"
  }

  provisioner "local-exec" {
    when       = "destroy"
    on_failure = "continue"
    command    = "kubectl config get-contexts | grep ${google_container_cluster.cluster.name} | xargs -n1 kubectl config delete-context"
  }
}
