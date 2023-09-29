output "resource_group_name" {
  value       = local.resource_group
  description = "The name of the resource group"
}

output "resource_group_location" {
  value       = var.location
  description = "The Azure region."
}

output "vnet_ids" {
  value       = { for key, value in var.vnets : key => azurerm_virtual_network.this[key].id if value.existing == false }
  description = "Map of vnet name to vnet id."
}

output "subnet_ids" {
  value       = { for subnet in local.flattened_subnets : "${subnet.vnet_key}-${subnet.subnet_key}" => azurerm_subnet.this["${subnet.vnet_key}-${subnet.subnet_key}"].id }
  description = "Map of subnet key to subnet id."
}

output "subnet_names" {
  value       = { for subnet in local.flattened_subnets : "${subnet.vnet_key}-${subnet.subnet_key}" => azurerm_subnet.this["${subnet.vnet_key}-${subnet.subnet_key}"].name }
  description = "Map of subnet key to subnet name."
}

output "route_table_ids" {
  value       = { for key, value in var.route_tables : key => azurerm_route_table.this[key].id }
  description = "Map of route table name to route table id."
}

output "network_security_groups_ids" {
  value       = { for key, value in var.network_security_groups : key => azurerm_network_security_group.this[key].id }
  description = "Map of network security group name to network security group id."
}
