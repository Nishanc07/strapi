variable "region" {
  default = "us-east-2"
}

variable "ecr_repo_name" {
  default = "nisha-ecr"
}

variable "account_id" {
  default = "607700977843"
  description = "Your AWS account ID"
}

variable "image_tag" {
  description = "Image tag pushed by CI (e.g., gh-1234567)"
}