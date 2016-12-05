# Tenant Variables
variable "TENANT_NAME" { default = "********" }
variable "TENANT_USER_NAME" { default = "********" }
variable "TENANT_USER_PASSWORD" { default = "********" }
variable "TENANT_AUTH_URL" { default = "https://********.metacloud.net:5000/v2.0" }

# Network Variables
# Networks
variable "WEB_NETWORK_NAME" { default = "cloudvt-web-network" }
variable "WEB_SUBNET_NAME" { default = "cloudvt-web-subnet" }
variable "WEB_NETWORK_CIDR" { default = "10.120.254.0/24" }

variable "PRIVATE_NETWORK_NAME" { default = "cloudvt-private-network" }
variable "PRIVATE_SUBNET_NAME" { default = "cloudvt-private-subnet" }
variable "PRIVATE_NETWORK_CIDR" { default = "10.120.0.0/20" }

# Router
variable "PUBLIC_ROUTER_NAME" { default = "cloudvt-public-router-1" }

# Floating IPs
variable "GATEWAY_NETWORK_ID" { default = "898c045d-9aac-4558-925f-e6663c0d830b" }
variable "LOCAL_NETWORKS" { default = "10.120.0.0/16" }

# Security Groups
variable "PRIVATE_SECGROUP_NAME" { default = "private-traffic-open" }
variable "SSH_SECGROUP_NAME" { default = "ssh-ingress" }
variable "WEB_SECGROUP_NAME" { default = "web-ingress" }

# Instance Variables
variable "KEY_NAME" { default = "jtg-key" }

variable "LINUX_IMAGE_NAME" { default = "ubuntu-1404-x86-64" }
variable "LINUX_IMAGE_ID" { default = "b2abd035-ebf1-421f-84b1-c95471758363" }
variable "LINUX_FLAVOR_NAME" { default = "m1.medium" }
variable "LINUX_FLAVOR_ID" { default = "2c8f5c26-9ecb-4351-b11e-8a3008e7a53e" }

variable "LB_SERVER_NAME" { default = "lb-server" }
variable "WEB_SERVER1_NAME" { default = "web-server1" }
variable "WEB_SERVER2_NAME" { default = "web-server2" }
variable "SQL_SERVER_NAME" { default = "sql-server" }
