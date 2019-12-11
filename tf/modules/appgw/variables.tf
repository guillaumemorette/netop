# Variables App Gateway

variable name {
  description = "Application Gateway name"
}

variable location {}

variable resource-group {
  description = "Resource Group name"
}

variable vnet-name {
  description = "target vnet name"
}

variable subnet-cidr {
  description = "app gateway dedicated subnet cidr"
}

variable backend-ip {
  description = "Backend IP to redirect flows"
}

variable fe-private-ip {
  description = "The Front End private IP"
}
