terraform {
  backend "remote" {
    organization = "hashicorp-learn"

    workspaces {
      name = "learn-terraform-pipelines-vault"
    }
  }
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0.2"
    }
  }

  required_version = "~> 0.14"
}

data "terraform_remote_state" "cluster" {
  backend = "remote"
  config = {
    organization = var.organization
    workspaces = {
      name = var.cluster_workspace
    }
  }
}

data "terraform_remote_state" "consul" {
  backend = "remote"
  config = {
    organization = var.organization
    workspaces = {
      name = var.consul_workspace
    }
  }
}

provider "helm" {
  kubernetes {
    host                   = data.terraform_remote_state.cluster.outputs.host
    username               = data.terraform_remote_state.cluster.outputs.username
    password               = data.terraform_remote_state.cluster.outputs.password
    cluster_ca_certificate = data.terraform_remote_state.cluster.outputs.cluster_ca_certificate

  }
}
