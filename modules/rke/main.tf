terraform {
  required_providers {
    rke = {
      source  = "rancher/rke"
      version = "1.0.1"
    }
  }
  required_version = ">= 0.13"
}

resource rke_cluster "cluster" {
cluster_name = "cluster"
  dynamic "nodes" {

    for_each = var.vm_address

    content {
      user = "david" 
      address = nodes.value
      internal_address = nodes.value
      role    = ["controlplane", "worker", "etcd"]
      ssh_key = file("~/.ssh/id_rsa")
    }

  }

}


resource "local_file" "kube_cluster_yaml" {
  filename = "${path.root}/kube_config_cluster.yml"
  content  = rke_cluster.cluster.kube_config_yaml
}