data "azurerm_subscription" "current" {}

locals {
  name           = var.name != null ? var.name : "${var.product}-${var.component}"
  is_prod        = length(regexall(".*(prod).*", var.env)) > 0
  resource_group = var.existing_resource_group_name == null ? azurerm_resource_group.new[0].name : var.existing_resource_group_name
  flattened_routes = flatten([
    for route_table_key, route_table in var.route_tables : [
      for route_key, route in route_table.routes : {
        route_table_key = route_table_key
        route_key       = route_key
        route           = route
      }
    ]
  ])
  flattened_subnet_route_associations = flatten([
    for route_table_key, route_table in var.route_tables : [
      for subnet in route_table.subnets : {
        route_table_key = route_table_key
        subnet          = subnet
      }
    ]
  ])
  flattened_nsg_rules = flatten([
    for nsg_key, nsg in var.network_security_groups : [
      for rule_key, rule in nsg.rules : {
        nsg_key  = nsg_key
        rule_key = rule_key
        rule     = rule
      }
    ]
  ])
  flattened_subnet_nsg_associations = flatten([
    for nsg_key, nsg in var.network_security_groups : [
      for subnet in nsg.subnets : {
        nsg_key = nsg_key
        subnet  = subnet
      }
    ]
  ])
  flattened_subnets = flatten([
    for vnet_key, vnet in var.vnets : [
      for subnet_key, subnet in vnet.subnets : {
        vnet_key   = vnet_key
        vnet       = vnet
        subnet_key = subnet_key
        subnet     = subnet
      }
    ]
  ])
}
