# This module creates a hcloud host, adds the DNS entries and sets the right rDNS entry in hcloud

locals {
	dns_name = var.dns_name != "" ? var.dns_name : var.server_name
}

resource "hcloud_server" "hcloud_host" {
  name = var.server_name
  image = var.image
  server_type = var.server_type
  datacenter = var.datacenter
  ssh_keys = var.ssh_keys

	labels = {
		Environment = var.environment
	}
}

resource "hcloud_rdns" "hcloud_host_rDNS_v6" {
  server_id = hcloud_server.hcloud_host.id
  ip_address = "${hcloud_server.hcloud_host.ipv6_address}"
  dns_ptr = "${local.dns_name}.${var.az_dns_zone.name}"
}

resource "hcloud_rdns" "hcloud_host_rDNS_v4" {
  server_id = hcloud_server.hcloud_host.id
  ip_address = hcloud_server.hcloud_host.ipv4_address
  dns_ptr = "${local.dns_name}.${var.az_dns_zone.name}"
}

resource "azurerm_dns_a_record" "hcloud_host_dns_entry" {
  name                = local.dns_name
  zone_name           = var.az_dns_zone.name
  resource_group_name = var.az_dns_zone.resource_group_name
  ttl                 = 300
  records             = [hcloud_server.hcloud_host.ipv4_address]

  tags = {
    Environment = var.environment
  }
}

resource "azurerm_dns_aaaa_record" "hcloud_host_dns_entry" {
  name                = local.dns_name
  zone_name           = var.az_dns_zone.name
  resource_group_name = var.az_dns_zone.resource_group_name
  ttl                 = 300
  records             = ["${hcloud_server.hcloud_host.ipv6_address}"]

  tags = {
    Environment = var.environment
  }
}

