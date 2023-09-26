resource "azurerm_network_security_group" "this" {
  for_each            = var.network_security_groups
  name                = "${local.name}-${each.key}-${var.env}"
  resource_group_name = local.resource_group
  location            = local.location
  tags                = var.common_tags
}

resource "azurerm_network_security_rule" "rules" {
  for_each                                   = { for rule in local.flattened_nsg_rules : "${rule.nsg_key}-${rule.rule_key}" => rule }
  network_security_group_name                = azurerm_network_security_group.this[each.value.nsg_key].name
  resource_group_name                        = local.resource_group
  name                                       = each.key
  priority                                   = each.value.rule.priority
  direction                                  = each.value.rule.direction
  access                                     = each.value.rule.access
  protocol                                   = each.value.rule.protocol
  source_port_range                          = each.value.rule.source_port_range
  source_port_ranges                         = each.value.rule.source_port_ranges
  destination_port_range                     = each.value.rule.destination_port_range
  destination_port_ranges                    = each.value.rule.destination_port_ranges
  source_address_prefix                      = each.value.rule.source_address_prefix
  source_address_prefixes                    = each.value.rule.source_address_prefixes
  source_application_security_group_ids      = each.value.rule.source_application_security_group_ids
  destination_address_prefix                 = each.value.rule.destination_address_prefix
  destination_address_prefixes               = each.value.rule.destination_address_prefixes
  destination_application_security_group_ids = each.value.rule.destination_application_security_group_ids
  description                                = each.value.rule.description
}

resource "azurerm_subnet_network_security_group_association" "this" {
  for_each                  = { for nsg in local.flattened_subnet_nsg_associations : "${nsg.nsg_key}-${nsg.subnet}" => nsg }
  subnet_id                 = azurerm_subnet.this[each.value.subnet].id
  network_security_group_id = azurerm_network_security_group.this[each.value.nsg_key].id
}
