terraform {
  backend "s3" {
    bucket = "terraform-state-backup-roboshopstore"
    key    = "vault-secrets/state"
    region = "us-east-1"
  }
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "4.5.0"
    }
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

resource "vault_mount" "roboshop-dev" {
  path = "roboshop-dev"
  type = "kv"
  options = {version =  "2" }
  description = "Roboshop Dev Secrets"
}

resource "vault_generic_secret" "roboshop-dev-cart" {
  path      = "${vault_mount.roboshop-dev.path}/cart"

  data_json = <<EOT
{
 "REDIS_HOST"    : "redis-dev.saitejasroboshop.store",
 "CATALOGUE_HOST": "catalogue-dev.saitejasroboshop.store",
 "CATALOGUE_PORT": "8080"
}
EOT
}

resource "vault_generic_secret" "roboshop-dev-catalogue" {
  path      = "${vault_mount.roboshop-dev.path}/catalogue"

  data_json = <<EOT
{
 "MONGO" : "true",
 "MONGO_URL" : "mongodb://mongodb-dev.saitejasroboshop.store:27017/catalogue"
}
EOT
}



resource "vault_generic_secret" "roboshop-dev-dispatch" {
  path      = "${vault_mount.roboshop-dev.path}/dispatch"

  data_json = <<EOT
{
 "AMQP_HOST"  : "rabbitmq-dev.saitejasroboshop.store",
 "AMQP_USER"  : "roboshop",
 "AMQP_PASS"  : "roboshop123"
}
EOT
}

