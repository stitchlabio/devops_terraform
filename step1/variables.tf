variable "az_count" {
  description = "Number of AZs to cover in a given AWS region"
  default     = "2"
}

variable "instance_tag" {
  description = "AWS instance tag Name"
}
