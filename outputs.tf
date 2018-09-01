output "gke_kube_config" {
    value = "gcloud container clusters get-credentials --zone=${var.gke_zone} ${google_container_cluster.cluster.name}"
}

output "aks_kube_config" {
    value = "az aks get-credentials --resource-group ${azurerm_resource_group.default.name} --name ${azurerm_kubernetes_cluster.cluster.name}"
}