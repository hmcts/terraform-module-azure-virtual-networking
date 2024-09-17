resource "azurerm_route_table" "this" {
  for_each                      = var.route_tables
  name                          = each.value.name_override == null ? "${local.name}-${each.key}-${var.env}" : each.value.name_override
  resource_group_name           = each.value.resource_group_override == null ? local.resource_group : each.value.resource_group_override
  location                      = var.location
  bgp_route_propagation_enabled = true
  tags                          = var.common_tags
}

resource "azurerm_route" "this" {
  for_each               = { for route in local.flattened_routes : "${route.route_table_key}-${route.route_key}" => route }
  name                   = each.value.route.name_override == null ? each.key : each.value.route.name_override
  resource_group_name    = azurerm_route_table.this[each.value.route_table_key].resource_group_name
  route_table_name       = azurerm_route_table.this[each.value.route_table_key].name
  address_prefix         = each.value.route.address_prefix
  next_hop_type          = each.value.route.next_hop_type
  next_hop_in_ip_address = each.value.route.next_hop_in_ip_address
}

resource "azurerm_subnet_route_table_association" "this" {
  for_each       = { for route_table in local.flattened_subnet_route_associations : "${route_table.route_table_key}-${route_table.subnet}" => route_table }
  subnet_id      = azurerm_subnet.this[each.value.subnet].id
  route_table_id = azurerm_route_table.this[each.value.route_table_key].id
}
