# terraform-module-azure-virtual-networking
Deploys Virtual Networks, subnets, route tables, security groups and associations to to Azure.

## Example

<!-- todo update module name -->
```hcl
module "networking" {
  source = "git@github.com:hmcts/terraform-module-azure-virtual-networking?ref=main"

  env         = var.env
  product     = var.product
  common_tags = var.common_tags
  component   = var.component

  vnets = {
    vnet1 = {
      address_space = ["10.10.10.0/23"]
      subnets = {
        subnet1 = {
          address_prefixes = ["10.10.10.0/24"]
        }
        delegated-subnet = {
          address_prefixes = ["10.10.11.0/24"]
          delegations = {
            flexibleserver = {
              service_name = "Microsoft.DBforPostgreSQL/flexibleServers"
              actions      = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
            }
          }
        }
      }
    }
  }

  route_tables = {
    rt = {
      subnets = ["vnet1-subnet1", "vnet1-delegated-subnet"]
      routes = {
        default = {
          address_prefix         = "0.0.0.0/0"
          next_hop_type          = "VirtualAppliance"
          next_hop_in_ip_address = "10.100.100.10/32"
        }
      }
    }
  }

  network_security_groups = {
    nsg = {
      subnets = ["vnet1-subnet1"]
      rules = {
        "allow_http" = {
          priority                   = 200
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "80"
          source_address_prefix      = "*"
          destination_address_prefix = "10.10.10.0/24"
        }
      }
    }
  }
}

```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.7.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_network_security_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.deny_inbound](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_resource_group.new](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_route.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route) | resource |
| [azurerm_route_table.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table) | resource |
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_route_table_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) | resource |
| [azurerm_virtual_network.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | Common tags to be applied to resources | `map(string)` | n/a | yes |
| <a name="input_component"></a> [component](#input\_component) | https://hmcts.github.io/glossary/#component | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | Environment value | `string` | n/a | yes |
| <a name="input_existing_resource_group_name"></a> [existing\_resource\_group\_name](#input\_existing\_resource\_group\_name) | Name of existing resource group to deploy resources into | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | Target Azure location to deploy the resource | `string` | `"UKSouth"` | no |
| <a name="input_name"></a> [name](#input\_name) | The default name will be product+component+env, you can override the product+component part by setting this | `string` | `null` | no |
| <a name="input_network_security_groups"></a> [network\_security\_groups](#input\_network\_security\_groups) | Map of network security groups to create. | <pre>map(object({<br>    name_override = optional(string)<br>    subnets       = optional(list(string))<br>    deny_inbound  = optional(bool, true)<br>    rules = map(object({<br>      name_override                              = optional(string)<br>      priority                                   = number<br>      direction                                  = string<br>      access                                     = string<br>      protocol                                   = string<br>      source_port_range                          = optional(string)<br>      source_port_ranges                         = optional(list(string))<br>      destination_port_range                     = optional(string)<br>      destination_port_ranges                    = optional(list(string))<br>      source_address_prefix                      = optional(string)<br>      source_address_prefixes                    = optional(list(string))<br>      source_application_security_group_ids      = optional(list(string))<br>      destination_address_prefix                 = optional(string)<br>      destination_address_prefixes               = optional(list(string))<br>      destination_application_security_group_ids = optional(list(string))<br>      description                                = optional(string)<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_product"></a> [product](#input\_product) | https://hmcts.github.io/glossary/#product | `string` | n/a | yes |
| <a name="input_route_tables"></a> [route\_tables](#input\_route\_tables) | Map of route tables to create. | <pre>map(object({<br>    name_override = optional(string)<br>    subnets       = list(string)<br>    routes = map(object({<br>      name_override          = optional(string)<br>      address_prefix         = string<br>      next_hop_type          = string<br>      next_hop_in_ip_address = optional(string)<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_vnets"></a> [vnets](#input\_vnets) | Map of virtual networks and associated subnets to create. Subnets can be created in existing virtual networks by setting existing to true. | <pre>map(object({<br>    name_override = optional(string)<br>    address_space = optional(list(string))<br>    existing      = optional(bool, false)<br>    subnets = map(object({<br>      name_override     = optional(string)<br>      address_prefixes  = list(string)<br>      service_endpoints = optional(list(string), [])<br>      delegations = optional(map(object({<br>        service_name = string,<br>        actions      = optional(list(string), [])<br>      })))<br>    }))<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_network_security_groups_ids"></a> [network\_security\_groups\_ids](#output\_network\_security\_groups\_ids) | Map of network security group name to network security group id. |
| <a name="output_resource_group_location"></a> [resource\_group\_location](#output\_resource\_group\_location) | The Azure region. |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The name of the resource group |
| <a name="output_route_table_ids"></a> [route\_table\_ids](#output\_route\_table\_ids) | Map of route table name to route table id. |
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | Map of subnet key to subnet id. |
| <a name="output_subnet_names"></a> [subnet\_names](#output\_subnet\_names) | Map of subnet key to subnet name. |
| <a name="output_vnet_ids"></a> [vnet\_ids](#output\_vnet\_ids) | Map of vnet key to vnet id. |
| <a name="output_vnet_names"></a> [vnet\_names](#output\_vnet\_names) | Map of vnet key to vnet name. |
<!-- END_TF_DOCS -->

## Contributing

We use pre-commit hooks for validating the terraform format and maintaining the documentation automatically.
Install it with:

```shell
$ brew install pre-commit terraform-docs
$ pre-commit install
```

If you add a new hook make sure to run it against all files:
```shell
$ pre-commit run --all-files
```
