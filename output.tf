output "dns_fqdn" {
    value = "${var.dns_name}.${var.az_dns_zone.name}"
}

output "hcloud_machine" {
    value = hcloud_server.hcloud_host
}
