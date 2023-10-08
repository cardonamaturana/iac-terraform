variable "access_key" {
  description = "access_key"
  type        = string
  sensitive   = true
}

variable "secret_key" {
  description = "secret_key"
  type        = string
  sensitive   = true
}

variable "instances_names" {
  description = "instances_names"
  type        = set(string)
  default     = []
}


