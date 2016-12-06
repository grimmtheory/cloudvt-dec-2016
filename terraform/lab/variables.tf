# Tenant Variables
variable "TENANT_NAME" { default = "cloudvt-terraform-lab" }
variable "TENANT_USER_NAME" { default = "cloudvt" }
variable "TENANT_USER_PASSWORD" { default = "cloudvt" }
variable "TENANT_AUTH_URL" { default = "https://api-cusps1.client.metacloud.net:5000/v2.0" }

# Router
variable "PUBLIC_ROUTER_NAME" { default = "team0-router1" }
variable "GATEWAY_NETWORK_ID" { default = "898c045d-9aac-4558-925f-e6663c0d830b" }

# Network
variable "PRIVATE_NETWORK_NAME" { default = "team0-network1" }
variable "PRIVATE_SUBNET_NAME" { default = "team0-subnet1" }
variable "PRIVATE_NETWORK_CIDR" { default = "10.0.0.0/24" }

# Instance Variables
variable "KEY_NAME" { default = "cloudvt-terraform" }
variable "LINUX_INSTANCE_NAME" { default = "team0-instance1" }
variable "LINUX_IMAGE_NAME" { default = "ubuntu-1404-x86-64" }
variable "LINUX_IMAGE_ID" { default = "b2abd035-ebf1-421f-84b1-c95471758363" }
variable "LINUX_FLAVOR_NAME" { default = "m1.medium" }
variable "LINUX_FLAVOR_ID" { default = "2c8f5c26-9ecb-4351-b11e-8a3008e7a53e" }

# Security Groups
variable "SECGROUP_NAME" { default = "team0-secgroup" }

# Floating IP Network
variable "FLOATING_IP_NETWORK_ID" { default = "898c045d-9aac-4558-925f-e6663c0d830b" }
