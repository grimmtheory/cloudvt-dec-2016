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

# Step 4 - Create a private network and connect it to your router

