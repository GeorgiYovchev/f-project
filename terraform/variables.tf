data "hcloud_ssh_key" "ssh_key" {
  name = "georgi@georgi-lab-ubnt"
}

variable "hcloud_token" {
  description = "Token for HCloud"
  type        = string
}

variable "name" {
  type    = string
  default = "the-server"
}

variable "image" {
  type    = string
  default = "ubuntu-22.04"
}

variable "server_type" {
  type    = string
  default = "cx21"
}

variable "location" {
  type    = string
  default = "nbg1"
}

variable "aws_region" {
  type    = string
  default = "eu-west-1"
}