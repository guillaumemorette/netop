# vnet modules variables

variable "name" {
  default = "default"
  description = "To define vnet and subnet names"
}

variable "resource-group" {
  description = "resource group name"
}

variable "vnet-cidr" {}
variable "subnet-cidr" {}
variable "location" {}


