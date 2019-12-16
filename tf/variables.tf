# Variables

variable location {}

variable apid-vnet-cidr {}
variable apid-subnet-cidr {}
variable apid-appgw-subnet-cidr {}
variable apid-appgw-private-ip {}
variable apid-target-host {
    description = "The host name to redirect to the ACI instance"
}

variable afa-vnet-cidr {}
variable afa-subnet-cidr {}
variable afa-appgw-subnet-cidr {}
variable afa-appgw-private-ip {}

variable afa-dns-zone-name {
    description = "The DNS zone name for the afa vnet"
}

variable afa-dns-record-name {
    description = "The wildcard A record to redirect to the App Gateway private IP"
}

variable afa-bastion-cidr {
    description = "The dedicated bastion cidr subnet"
}