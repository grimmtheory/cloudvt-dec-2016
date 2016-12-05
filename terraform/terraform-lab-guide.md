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
