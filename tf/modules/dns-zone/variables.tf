# DNS Zone variables

variable resource-group {}

variable vnet-id {
    description = "The VNET Id to link the DNS Zone"
}

variable dns-zone-name {
    description = "The DNS zone name, for example afa.azure.extra"
}

variable dns-record-name {
    description = "One A record name, for example *.vnet-tribe"
}

variable dns-record-ip {
    description = "IP corresponding to the dns-record-name"
}
