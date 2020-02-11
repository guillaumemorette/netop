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

variable backend-ips {
  description = "List Backend IP to redirect flows"
}

variable backend-fqdns {
  description = "List FQDN to redirect flows"
}

variable fe-private-ip {
  description = "The Front End private IP"
}

variable listener {
  description = "public if the app gateway listen on the public IP, private if the app gateway listen on the private IP"
}

variable target-host {
  description = "the host name to redirect"
}

variable backend-ca-certificate {
  description = "trusted ca root certificate filename from project directory. ex: 'scripts/ssl.crt'"
}

variable pfx-certificate {
  description = "pfx filename for the app gateway ssl termination. ex: 'ssl/appgw-cert.pfx'"
}

variable pfx-password {
  description = "pfx file password"
}

variable probe-hostname {
  description = "the backend probe hostname, wildcard not supported"
}
