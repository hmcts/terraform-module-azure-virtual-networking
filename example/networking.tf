module "networking" {
  source = "../."

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
