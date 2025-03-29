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
  options     = { version : "2" }
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

resource "vault_generic_secret" "github-runner" {
  path = "${vault_mount.ssh.path}/github-runner"

  data_json = <<EOT
{
   "RUNNER_TOKEN":   "xx",
}
EOT
}

resource "vault_mount" "roboshop-dev" {
  path = "roboshop-dev"
  type = "kv"
  options = {version :  "2" }
  description = "Roboshop Dev Secrets"
}

# Cart Secrets
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

#Catalogue Secrets

resource "vault_generic_secret" "roboshop-dev-catalogue" {
  path      = "${vault_mount.roboshop-dev.path}/catalogue"

  data_json = <<EOT
{
 "MONGO" : "true",
 "MONGO_URL" : "mongodb://mongodb-dev.saitejasroboshop.store:27017/catalogue",
 "DB_TYPE": "mongo",
 "APP_GIT_URL" : "https://github.com/roboshop-devops-project-v3/catalogue",
 "DB_HOST" : "mongodb-dev.saitejasroboshop.store",
 "SCHEMA_FILE" : "db/master-data.js"
}
EOT
}

#Dispatch Secrets

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



# Frontend Secrets
resource "vault_generic_secret" "roboshop-dev-frontend" {
  path = "${vault_mount.roboshop-dev.path}/frontend"

  data_json = <<EOT
{
"catalogue" :   "http://catalogue-dev.saitejasroboshop.store:8080/",
"user"      :   "http://user-dev.saitejasroboshop.store:8080/",
"cart"      :   "http://cart-dev.saitejasroboshop.store:8080/",
"shipping"  :   "http://shipping-dev.saitejasroboshop.store:8080/",
"payment"   :   "http://payment-dev.saitejasroboshop.store:8080/",
"CATALOGUE_HOST"  : "catalogue-dev.saitejasroboshop.store",
"CATALOGUE_PORT"  : "8080",
"USER_HOST"     : "user-dev.saitejasroboshop.store",
"USER_PORT"     : "8080",
"CART_HOST"     :  "cart-dev.saitejasroboshop.store",
"CART_PORT"     : "8080",
"SHIPPING_HOST" : "shipping-dev.saitejasroboshop.store",
"SHIPPING_PORT" :  "8080",
"PAYMENT_HOST"  : "payment-dev.saitejasroboshop.store",
"PAYMENT_PORT"  : "8080"

}
EOT
}

#Payment Secrets

resource "vault_generic_secret" "roboshop-dev-payment" {
  path = "${vault_mount.roboshop-dev.path}/payment"

  data_json = <<EOT
{
"CART_HOST" : "cart-dev.saitejasroboshop.store",
"CART_PORT" : "8080",
"USER_HOST" : "user-dev.saitejasroboshop.store",
"USER_PORT" : "8080",
"AMQP_HOST" : "rabbitmq-dev.saitejasroboshop.store",
"AMQP_USER" : "roboshop",
"AMQP_PASS" : "roboshop123"
}
EOT
}

# Shipping Secrets
resource "vault_generic_secret" "roboshop-dev-shipping" {
  path = "${vault_mount.roboshop-dev.path}/shipping"

  data_json = <<EOT
{
"CART_ENDPOINT" : "cart-dev.saitejasroboshop.store:8080",
"DB_HOST" : "mysql-dev.saitejasroboshop.store",
"DB_TYPE" : "mysql",
"APP_GIT_URL" : "https://github.com/roboshop-devops-project-v3/shipping",
"DB_USER" : "root",
"DB_PASS" : "RoboShop@1"

}
EOT
}

# User Secrets

resource "vault_generic_secret" "roboshop-dev-user" {
  path = "${vault_mount.roboshop-dev.path}/user"

  data_json = <<EOT
{
"MONGO" : "true",
"REDIS_URL" : "redis://redis-dev.saitejasroboshop.store:6379",
"MONGO_URL" : "mongodb://mongodb-dev.saitejasroboshop.store:27017/users"
}
EOT
}