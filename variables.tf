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
      iam_policy    = {
        Action      = []
        Resource    = []
      }
    }
    github-runner = {
      instance_type = "t3.small"
      port = 443 #Dummy Port
      iam_policy    = {
        Action      = ["*"]
        Resource    = []
      }
    }
  }
}