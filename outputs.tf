output "gke_kube_config" {
    value = "gcloud container clusters get-credentials --zone=${var.gke_zone} ${google_container_cluster.cluster.name}"
}