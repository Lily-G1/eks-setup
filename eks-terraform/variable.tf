variable "ssh_key_name" {
  description = "The name of the SSH key pair to use for instances"
  type        = string
  default     = "{aws keypair name here}"
}

variable "cluster_name" {
  description = "The name of eks cluster"
  type        = string
  default     = "{cluster name here}"
}
