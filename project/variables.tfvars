# Set variables

location = "westeurope"

### APID definition ###

apid-vnet-cidr = "10.1.0.0/16"

apid-subnet-cidr = "10.1.1.0/24"

apid-appgw-subnet-cidr = "10.1.2.0/28"

apid-appgw-private-ip = "10.1.2.10"

apid-target-host = "hello.aci1.apid.vnet-tribe.afa.azure.extraxa"

apid-storage-account-name = "gm47nginxstorage"

apid-storage-share-name = "nginxshare"


#### AFA definition ###

afa-vnet-cidr = "10.1.0.0/16"

afa-subnet-cidr = "10.1.1.0/24"

afa-appgw-subnet-cidr = "10.1.2.0/28"

afa-appgw-private-ip = "10.1.2.10"

afa-dns-zone-name = "afa.azure.extraxa"

afa-dns-record-name = "*.vnet-tribe"

afa-bastion-cidr = "10.1.3.0/27"
