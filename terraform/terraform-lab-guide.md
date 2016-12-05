# Step 1 - Access to Terraform

In order to perform the functions of the Terraform lab you will first need access to Terraform.  You can accomplish this in one of 2 ways.

## Option 1 - Use the jumpbox provided

We have provided a jumpbox with Terraform pre-installed as well as a clone of the repository, sample contents, etc.  Use the information below to gain access:

- Login - get from session instructor
- Password - get from session instructor
- IP Address - 199.66.189.253

For Mac / Linux users - ssh <username>@199.66.189.253
For Windows users - use putty or similar terminal emulator

_There are no ssh keys required from access to the jumpbox, ssh password auth is available, be courteous of your neighbors : )_

## Option 2 - Download and install Terraform and lab content locally

If you want to continue working with the tools and have a local copy of the content for after the session, then a local installation is the option to choose.

### To download and install Terraform

- Download Terrafrom through the UI from here https://www.terraform.io/downloads.html
- Or from the cli, for example, wget https://releases.hashicorp.com/terraform/0.7.13/terraform_0.7.13_linux_amd64.zip
- Unzip terraform_0.7.13_linux_amd64.zip
- For Mac / Linux users, chmod +x terraform and sudo cp terraform /usr/local/bin

### To clone the content

- git clone https://github.com/grimmtheory/cloudvt-dec-2016.git

# Step 2 - Basic Terraform Configuration and Testing

Before we start building infrastructure with Terraform, let's first make sure we have some working basics like:

- a main.tf
- a variables.tf
- a working cloud provider

You can start with the examples in the cloned git repository or you can start from scratch.

_Note, the variables file is optional, you can hard code everything in main.tf, but it makes the platform much more difficult to move between environments_sss

The variables.tf at this point should look similar to this:

```sh
# Tenant Variables
variable "TENANT_NAME" { default = "********" }
variable "TENANT_USER_NAME" { default = "********" }
variable "TENANT_USER_PASSWORD" { default = "********" }
variable "TENANT_AUTH_URL" { default = "https://********.metacloud.net:5000/v2.0" }
```

And your main.tf should look similar to this:

```sh
# Configure the OpenStack Provider
provider "openstack" {
  tenant_name = "${var.TENANT_NAME}"
  user_name = "${var.TENANT_USER_NAME}"
  password = "${var.TENANT_USER_PASSWORD}"
  auth_url = "${var.TENANT_AUTH_URL}"
}
```

When your files are complete, test the configuration by running terraform apply

```sh
$ terraform plan
$ terraform apply
```

If everything is configured correctly you should see the following message

```sh
Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
```

# Step 3 - Create a router and attach it to the public network

_NOTE - To avoid confusion w/ other lab teams, use a unique name for your infrastructure, e.g. team#-router-1, team#-network-1, etc._

To create a router, add the following, or something similar, to variables.tf

```sh
# Router
variable "PUBLIC_ROUTER_NAME" { default = "team0-router1" }
variable "GATEWAY_NETWORK_ID" { default = "898c045d-9aac-4558-925f-e6663c0d830b" }
```

And to main.tf

```sh
# Create public router
resource "openstack_networking_router_v2" "public_router" {
  name = "${var.PUBLIC_ROUTER_NAME}"
  admin_state_up = "true"
  external_gateway = "${var.GATEWAY_NETWORK_ID}"
}
```

Once complete we can now try our first terraform apply to build infrastructure, run

```sh
$ terraform plan
$ terraform apply
```

and you should see output similar to this

```sh
openstack_networking_router_v2.public_router: Creating...
  admin_state_up:   "" => "true"
  distributed:      "" => "<computed>"
  external_gateway: "" => "898c045d-9aac-4558-925f-e6663c0d830b"
  name:             "" => "team0-router1"
  tenant_id:        "" => "<computed>"
openstack_networking_router_v2.public_router: Creation complete

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

The state of your infrastructure has been saved to the path
below. This state is required to modify and destroy your
infrastructure, so keep it safe. To inspect the complete state
use the `terraform show` command.

State path: terraform.tfstate
```

Log into the web-ui, or use the openstack cli tools (already installed), to view your new router.

Let's go ahead and tear down our changes as we're going to build on them each time, run

```sh
terraform destroy
```

Your output should look similar to this

```sh
Do you really want to destroy?
  Terraform will delete all your managed infrastructure.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

openstack_networking_router_v2.public_router: Refreshing state... (ID: d91d27cb-6ca4-4073-bcbb-3482575a38a3)
openstack_networking_router_v2.public_router: Destroying...
openstack_networking_router_v2.public_router: Destruction complete

Destroy complete! Resources: 1 destroyed.
```

# Step 4 - Create a private network, a subnet and connect it to your router

Similar to how we created the router and gateway, let's now create a private network and attach it to the router

Add something similar to this to your variables.tf file

```sh
# Network
variable "PRIVATE_NETWORK_NAME" { default = "team0-network1" }
variable "PRIVATE_SUBNET_NAME" { default = "team0-subnet1" }
variable "PRIVATE_NETWORK_CIDR" { default = "10.0.0.0/24" }
```

_Note, due to neutron name spaces you can have duplicate private ip ranges, however, to avoid confusion you may want to pick something random or that won't overlap, e.g. for team1 use 10.1.1.0/24, for team2 10.2.2.0/24 and so on_

Add something similar to this to your main.tf file

```sh
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
```

Once complete apply the new configuration

```sh
$ terraform plan
$ terraform apply
```

If everything worked the output should look similar to this

```sh
openstack_networking_router_v2.public_router: Creation complete
openstack_networking_subnet_v2.private_subnet: Creation complete
openstack_networking_router_interface_v2.private_router_interface: Creating...
  router_id: "" => "1b55b156-d4a2-443f-8314-f892bd045d34"
  subnet_id: "" => "8ceb0647-37f2-43f5-92e1-eebe4c4428e3"
openstack_networking_router_interface_v2.private_router_interface: Creation complete

Apply complete! Resources: 4 added, 0 changed, 0 destroyed.

The state of your infrastructure has been saved to the path
below. This state is required to modify and destroy your
infrastructure, so keep it safe. To inspect the complete state
use the `terraform show` command.

State path: terraform.tfstate
```

Once again run terraform destroy to start fresh on the next step

```sh
$ terraform destroy
```

# Step 5 - Boot a VM on the new network

As with previous steps, let's add the relevant content to the variables.tf and main.tf files.

Append variables.tf with the following information

```sh
# Instance Variables
variable "KEY_NAME" { default = "cloudvt-terraform" }
variable "LINUX_INSTANCE_NAME" { default = "team0-instance1" }
variable "LINUX_IMAGE_NAME" { default = "ubuntu-1404-x86-64" }
variable "LINUX_IMAGE_ID" { default = "b2abd035-ebf1-421f-84b1-c95471758363" }
variable "LINUX_FLAVOR_NAME" { default = "m1.medium" }
variable "LINUX_FLAVOR_ID" { default = "2c8f5c26-9ecb-4351-b11e-8a3008e7a53e" }
```

Append main.tf with the following information

```sh
resource "openstack_compute_instance_v2" "instance1" {
  name = "${var.LINUX_INSTANCE_NAME}"
  image_name = "${var.LINUX_IMAGE_NAME}"
  image_id = "${var.LINUX_IMAGE_ID}"
  flavor_name = "${var.LINUX_FLAVOR_NAME}"
  flavor_id = "${var.LINUX_FLAVOR_ID}"
  key_pair = "${var.KEY_NAME}"
  security_groups = ["default"]

  network {
    name = "${var.PRIVATE_NETWORK_NAME}"
  }
}
```

Once again run plan and apply and verify your results.  If everything looks good then do another terraform destroy to start with a clean slate on the next step, or, alternately, if you're confident that you've got the process down then leave the infrastructure up and experiment with incremental "applys" going forward.

```sh
$ terraform plan
$ terraform apply
# verify results and optionally destroy or keep
$ terraform destroy
```

# Step 6 - Add Security Groups


# Step 7 - Add Floating IPs


# Step 8 - Experiment with config drive, user data or remote exec options
