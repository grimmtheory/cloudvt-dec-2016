# Configure the OpenStack Provider
provider "openstack" {
  tenant_name = "${var.TENANT_NAME}"
  user_name = "${var.TENANT_USER_NAME}"
  password = "${var.TENANT_USER_PASSWORD}"
  auth_url = "${var.TENANT_AUTH_URL}"
}

# Create public router
resource "openstack_networking_router_v2" "public_router" {
  name = "${var.PUBLIC_ROUTER_NAME}"
  admin_state_up = "true"
  external_gateway = "${var.GATEWAY_NETWORK_ID}"
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

# Attach public router to private subnet
resource "openstack_networking_router_interface_v2" "private_router_interface" {
  router_id = "${openstack_networking_router_v2.public_router.id}"
  subnet_id = "${openstack_networking_subnet_v2.private_subnet.id}"
}

# Create security group
resource "openstack_compute_secgroup_v2" "secgroup_1" {
  name = "${var.SECGROUP_NAME}"
  description = "my security group"
  rule {
    from_port = 22
    to_port = 22
    ip_protocol = "tcp"
    cidr = "0.0.0.0/0"
  }
  rule {
    from_port = 80
    to_port = 80
    ip_protocol = "tcp"
    cidr = "0.0.0.0/0"
  }
}

resource "openstack_compute_floatingip_v2" "instance1-floating-ip" {
  pool = "${var.FLOATING_IP_NETWORK_ID}"
}

# Create instance
resource "openstack_compute_instance_v2" "instance1" {
  depends_on = ["openstack_networking_network_v2.private_network"]
  name = "${var.LINUX_INSTANCE_NAME}"
  image_name = "${var.LINUX_IMAGE_NAME}"
  image_id = "${var.LINUX_IMAGE_ID}"
  flavor_name = "${var.LINUX_FLAVOR_NAME}"
  flavor_id = "${var.LINUX_FLAVOR_ID}"
  key_pair = "${var.KEY_NAME}"
  security_groups = ["${openstack_compute_secgroup_v2.secgroup_1.name}"]
//  security_groups = ["default"]
  user_data = "${file("web.sh")}"

  network {
    name = "${var.PRIVATE_NETWORK_NAME}"
    floating_ip = "${openstack_compute_floatingip_v2.instance1-floating-ip.address}"
  }
}

output "private-network-name" {
  value = "${openstack_networking_network_v2.private_network.name}"
}

output "private-network-id" {
  value = "${openstack_networking_network_v2.private_network.id}"
}
