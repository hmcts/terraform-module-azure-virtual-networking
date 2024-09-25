resource "azurerm_virtual_network" "this" {
  for_each            = { for key, value in var.vnets : key => value if value.existing == false }
  name                = each.value.name_override == null ? "${local.name}-${each.key}-${var.env}" : each.value.name_override
  address_space       = each.value.address_space
  resource_group_name = local.resource_group
  location            = var.location
  tags                = var.common_tags
}

resource "azurerm_subnet" "this" {
  for_each                          = { for subnet in local.flattened_subnets : "${subnet.vnet_key}-${subnet.subnet_key}" => subnet }
  name                              = each.value.subnet.name_override == null ? "${local.name}-${each.value.subnet_key}-${var.env}" : each.value.subnet.name_override
  resource_group_name               = local.resource_group
  virtual_network_name              = each.value.vnet.existing ? each.value.vnet_key : azurerm_virtual_network.this[each.value.vnet_key].name
  address_prefixes                  = each.value.subnet.address_prefixes
  service_endpoints                 = each.value.subnet.service_endpoints
  private_endpoint_network_policies = each.value.subnet.private_endpoint_network_policies

  dynamic "delegation" {
    for_each = each.value.subnet.delegations != null ? each.value.subnet.delegations : {}
    content {
      name = delegation.key
      service_delegation {
        name    = delegation.value.service_name
        actions = delegation.value.actions
      }
    }
  }
}
