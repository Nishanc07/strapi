variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "image_tag" {
  description = "Image tag to deploy from ECR"
  type        = string
}
