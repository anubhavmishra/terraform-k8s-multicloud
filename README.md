# terraform-k8s-multicloud
Terraform configuration to create Kubernetes clusters in GKE, AKS and EKS.

## Usage

Run Terraform plan and apply

```bash
terraform plan
terraform apply -auto-approve
```

Expected output.

```bash
.....
Apply complete! Resources: 6 added, 0 changed, 0 destroyed.

Outputs:

aks_kube_config = az aks get-credentials --resource-group consul-k8s-xxxxx --name consul-k8s-xxxxx
gke_kube_config = gcloud container clusters get-credentials --zone=us-central1-a consul-k8s-xxxxx
```

Configure kubectl to use the GKE cluster

```bash
$(terraform output gke_kube_config)
```

Expected output.

```bash
Fetching cluster endpoint and auth data.
kubeconfig entry generated for consul-k8s-xxxxx.
```

Configure kubectl to use the AKS cluster

```bash 
$(terraform output aks_kube_config)
```

Expected output.

```bash
Merged "consul-k8s-xxxxx" as current context in /Users/anubhavmishra/.kube/config
```

## TODO

- [ ] Add EKS.