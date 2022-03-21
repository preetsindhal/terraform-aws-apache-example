# AWS VPC Terraform module

This is just demo on how to create a module for terraform.
Not intended for production use.

## Usage

```hcl
terraform {

}
provider "aws" {
  region = "us-east-1"
}

module "apache" {
  source           = ".//terraform-aws-apache-example"
  vpc_id           = "vpc-00000000"
  subnet_id        = "subnet-00000000"
  ssh_key_pub      = "ssh-rsa AAAAB"...
  my_ip_with_cider = "MY_OWN_IP_ADDRESS/32"
}

output "apache_server_ip" {
  value = module.apache.instace_ip_address
}
```