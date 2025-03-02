terraform {
  backend "s3" {
    bucket = "terraform-state-backup-roboshopstore"
    key    = "vault-secrets/state"
    region = "us-east-1"
  }
}


provider "vault" {
  address = "http://vault-internal.saitejasroboshop.store:8200"
  token = var.vault_token
}

variable "vault_token" {}

resource "vault_mount" "ssh" {
  path        = "infra"
  type        = "kv"
  options     = { version = "2" }
  description = "Infra secrets"
}

resource "vault_generic_secret" "ssh" {
  path = "${vault_mount.ssh.path}/ssh"

  data_json = <<EOT
{
  "username":   "ec2-user",
  "password": "DevOps321"
}
EOT
}



