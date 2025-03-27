terraform {
  backend "s3" {
    bucket = "terraform-state-backup-roboshopstore"
    key    = "tools/state"
    region = "us-east-1"
  }
}


variable "ami_id" {
  default = "ami-09c813fb71547fc4f"
}

variable "zone_id" {
  default = "Z0742899AVG59Z59WGO9"
}

variable "tools" {
  default = {
    vault = {
      instance_type = "t3.small"
      port = 8200
  }
    github-runner = {
      instance_type = "t3.small"
      port = 443 #Dummy Port
    }
  }
}

module "tool-infra" {
  source = "./module-infra"
  for_each = var.tools
  ami_id = var.ami_id
  instance_type = each.value["instance_type"]
  name = each.key
  port = each.value["port"]
  zone_id = var.zone_id
}