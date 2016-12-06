// Metacloud - CloudVT Tenant Setup; contact Jason Grimm (jasgrimm@cisco.com) for questions

# Configure the OpenStack Provider
provider "openstack" {
  tenant_name = "${var.TENANT_NAME}"
  user_name = "${var.TENANT_USER_NAME}"
  password = "${var.TENANT_USER_PASSWORD}"
  auth_url = "${var.TENANT_AUTH_URL}"
}

# Create private network
resource "openstack_networking_network_v2" "private_network" {
  name = "${var.PRIVATE_NETWORK_NAME}"
  admin_state_up = "true"
}

# Create private subnet
resource "openstack_networking_subnet_v2" "private_subnet" {
  name = "${var.PRIVATE_SUBNET_NAME}"
  network_id = "${openstack_networking_network_v2.private_network.id}"
  cidr = "${var.PRIVATE_NETWORK_CIDR}"
  ip_version = "4"
  enable_dhcp = "true"
}

# Create public network
resource "openstack_networking_network_v2" "web_network" {
  name = "${var.WEB_NETWORK_NAME}"
  admin_state_up = "true"
}

# Create public subnet
resource "openstack_networking_subnet_v2" "web_subnet" {
  name = "${var.WEB_SUBNET_NAME}"
  network_id = "${openstack_networking_network_v2.web_network.id}"
  cidr = "${var.WEB_NETWORK_CIDR}"
  ip_version = "4"
  enable_dhcp = "true"
}

# Create public router
resource "openstack_networking_router_v2" "public_router" {
  name = "${var.PUBLIC_ROUTER_NAME}"
  admin_state_up = "true"
  external_gateway = "${var.GATEWAY_NETWORK_ID}"
}

# Attach public router to public subnet
resource "openstack_networking_router_interface_v2" "public_router_interface" {
  router_id = "${openstack_networking_router_v2.public_router.id}"
  subnet_id = "${openstack_networking_subnet_v2.web_subnet.id}"
}

# Attach public router to private subnet
resource "openstack_networking_router_interface_v2" "private_router_interface" {
  router_id = "${openstack_networking_router_v2.public_router.id}"
  subnet_id = "${openstack_networking_subnet_v2.private_subnet.id}"
}

# Create security groups
# Private security group
resource "openstack_networking_secgroup_v2" "secgroup_private" {
  name = "${var.PRIVATE_SECGROUP_NAME}"
  description = "security group for internal traffic"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_private_rule_1" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 1
  port_range_max = 65535
  remote_ip_prefix = "${var.LOCAL_NETWORKS}"
  security_group_id = "${openstack_networking_secgroup_v2.secgroup_private.id}"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_private_rule_2" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "udp"
  port_range_min = 1
  port_range_max = 65535
  remote_ip_prefix = "${var.LOCAL_NETWORKS}"
  security_group_id = "${openstack_networking_secgroup_v2.secgroup_private.id}"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_private_rule_3" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "icmp"
  remote_ip_prefix = "${var.LOCAL_NETWORKS}"
  security_group_id = "${openstack_networking_secgroup_v2.secgroup_private.id}"
}

# SSH security group
resource "openstack_networking_secgroup_v2" "secgroup_ssh" {
  name = "${var.SSH_SECGROUP_NAME}"
  description = "security group for ssh ingress traffic"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_ssh_rule_1" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 22
  port_range_max = 22
  remote_ip_prefix = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.secgroup_ssh.id}"
}

# HTTP and HTTPS security group
resource "openstack_networking_secgroup_v2" "secgroup_web" {
  name = "${var.WEB_SECGROUP_NAME}"
  description = "security group for http ingress traffic"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_web_rule_1" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 80
  port_range_max = 80
  remote_ip_prefix = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.secgroup_web.id}"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_web_rule_2" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 443
  port_range_max = 443
  remote_ip_prefix = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.secgroup_web.id}"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_web_rule_3" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 8001
  port_range_max = 8002
  remote_ip_prefix = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.secgroup_web.id}"
}

# Generate output
output "  PRIVATE_NETWORK_NAME:" {
  value = "${openstack_networking_network_v2.private_network.name}"
}

output "  PRIVATE_NETWORK_ID:" {
  value = "${openstack_networking_network_v2.private_network.id}"
}

output "  WEB_NETWORK_NAME:" {
  value = "${openstack_networking_network_v2.web_network.name}"
}

output "  WEB_NETWORK_ID:" {
  value = "${openstack_networking_network_v2.web_network.id}"
}

output "  SSH_SECGROUP_NAME:" {
  value = "${openstack_networking_secgroup_v2.secgroup_ssh.name}"
}

output "  SSH_SECGROUP_ID:" {
  value = "${openstack_networking_secgroup_v2.secgroup_ssh.id}"
}

output "  PRIVATE_SECGROUP_NAME:" {
  value = "${openstack_networking_secgroup_v2.secgroup_private.name}"
}

output "  PRIVATE_SECGROUP_ID:" {
  value = "${openstack_networking_secgroup_v2.secgroup_private.id}"
}

output "  WEB_SECGROUP_NAME:" {
  value = "${openstack_networking_secgroup_v2.secgroup_web.name}"
}

output "  WEB_SECGROUP_ID:" {
  value = "${openstack_networking_secgroup_v2.secgroup_web.id}"
}

output "  KEY_NAME:" {
  value = "${var.KEY_NAME}"
}

output "  GATEWAY_NETWORK_ID:" {
  value = "${var.GATEWAY_NETWORK_ID}"
}

output "  LB_SERVER_NAME:" {
  value = "${var.LB_SERVER_NAME}"
}

output "  WEB_SERVER1_NAME:" {
  value = "${var.WEB_SERVER1_NAME}"
}

output "  WEB_SERVER2_NAME:" {
  value = "${var.WEB_SERVER2_NAME}"
}

output "  SQL_SERVER_NAME:" {
  value = "${var.SQL_SERVER_NAME}"
}

output "  LINUX_IMAGE_NAME:" {
  value = "${var.LINUX_IMAGE_NAME}"
}

output "  LINUX_IMAGE_ID:" {
  value = "${var.LINUX_IMAGE_ID}"
}

output "  LINUX_FLAVOR_NAME:" {
  value = "${var.LINUX_FLAVOR_NAME}"
}

output "  LINUX_FLAVOR_ID:" {
  value = "${var.LINUX_FLAVOR_ID}"
}
