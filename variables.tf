variable "vpc_id" {
  type = string
}
variable "instance_type" {
  type = string
  default = "t2.micro"
}
variable "ssh_key_pub" {
  type = string
}
variable "subnet_id" {
  type = string
}
variable instance_name {
    type = string
    default = "tf-aws-apache-vm"
}
variable "my_ip_with_cider" {
  type = string
  description = "Provie your IP eg. 202.14.120.63/32"
}