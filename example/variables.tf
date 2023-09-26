variable "env" {
  default = "test"
}

variable "common_tags" {
  description = "Common tags to be applied to resources"
  type        = map(string)
  default     = {}
}

variable "product" {
  default = "mgmt"
}

variable "component" {
  default = "data"
}
