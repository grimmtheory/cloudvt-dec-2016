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

The variables.tf at this point should look similar to this:

```# Tenant Variables
variable "TENANT_NAME" { default = "********" }
variable "TENANT_USER_NAME" { default = "********" }
variable "TENANT_USER_PASSWORD" { default = "********" }
variable "TENANT_AUTH_URL" { default = "https://********.metacloud.net:5000/v2.0" }
```

And your main.tf should look similar to this:

```# Configure the OpenStack Provider
provider "openstack" {
  tenant_name = "${var.TENANT_NAME}"
  user_name = "${var.TENANT_USER_NAME}"
  password = "${var.TENANT_USER_PASSWORD}"
  auth_url = "${var.TENANT_AUTH_URL}"
}
```

When your files are complete, test the configuration by running terraform apply

```$ terraform apply
```


