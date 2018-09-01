variable "gke_k8s_version" {
  default     = "1.10.5-gke.4"
  description = "The K8S version to use for both master and nodes."
}

variable "gke_project" {
  description = <<EOF
Google Cloud Project to launch resources in. This project must have GKE
enabled and billing activated. We can't use the GOOGLE_PROJECT environment
variable since we need to access the project for other uses.
EOF
}

variable "gke_zone" {
  default     = "us-central1-a"
  description = "The zone to launch all the GKE nodes in."
}

variable "gke_init_cli" {
  default = false
  description = "Whether to init the CLI tools kubectl, helm, etc. or not."
}

## AKS variables

variable "aks_rg_location" {
  default = "centralus"
}

variable "client_id" {
  description = "client_id from your Azure login settings, this can be set using an environment variable by prefixing the env var with TF_VAR_client_id"
}

variable "client_secret" {
  description = "client_secret from your Azure login settings, this can be set using an environment variable by prefixing the env var with TF_VAR_client_secret"
}