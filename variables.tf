variable "server_name" {}

variable "dns_name" {
	default=""
}

variable "image" {
	default="debian-10"
}

variable "server_type" {
	default="cx11"
}

variable "datacenter" {
	default="fsn1-dc14"
}

variable "ssh_keys" {
	type=list(string)
}

variable "az_dns_zone" {}

variable "environment" {}
