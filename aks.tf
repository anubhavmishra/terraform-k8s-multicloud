provider "azurerm" {}

// Create a private key for the bastion host and k8s
resource "tls_private_key" "server" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

// Save the private key locally in the root directory of the project 
// rather than using an output variable to access it.
resource "null_resource" "save-key" {
  triggers {
    key = "${tls_private_key.server.private_key_pem}"
  }

  provisioner "local-exec" {
    command = <<EOF
      mkdir -p ${path.module}/.ssh
      echo "${tls_private_key.server.private_key_pem}" > ${path.module}/.ssh/id_rsa
      chmod 0600 ${path.module}/.ssh/id_rsa
EOF
  }

  provisioner "local-exec" {
    when       = "destroy"
    on_failure = "continue"
    command    = "rm -rf ${path.module}/.ssh"
  }
}

resource "azurerm_resource_group" "default" {
  name     = "consul-k8s-${random_id.suffix.dec}"
  location = "${var.aks_rg_location}"
}

resource "azurerm_kubernetes_cluster" "cluster" {
  name                = "consul-k8s-${random_id.suffix.dec}"
  location            = "${azurerm_resource_group.default.location}"
  resource_group_name = "${azurerm_resource_group.default.name}"
  dns_prefix          = "consul-k8s"

  linux_profile {
    admin_username = "azureuser"

    ssh_key {
      key_data = "${tls_private_key.server.public_key_openssh}"
    }
  }

  agent_pool_profile {
    name            = "default"
    count           = 5
    vm_size         = "Standard_DS2_v2"
    os_type         = "Linux"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = "${var.client_id}"
    client_secret = "${var.client_secret}"
  }
}