variable "existing_resource_group_name" {
  description = "Name of existing resource group to deploy resources into"
  type        = string
  default     = null
}

variable "location" {
  description = "Target Azure location to deploy the resource"
  type        = string
  default     = "UKSouth"
}

variable "name" {
  type        = string
  default     = null
  description = "The default name will be product+component+env, you can override the product+component part by setting this"
}

variable "vnets" {
  type = map(object({
    name_override                     = optional(string)
    address_space                     = optional(list(string))
    existing                          = optional(bool, false)
    private_endpoint_network_policies = optional(string, "Disabled")
    subnets = map(object({
      name_override     = optional(string)
      address_prefixes  = list(string)
      service_endpoints = optional(list(string), [])
      delegations = optional(map(object({
        service_name = string,
        actions      = optional(list(string), [])
      })))
    }))
  }))
  description = "Map of virtual networks and associated subnets to create. Subnets can be created in existing virtual networks by setting existing to true."
  default     = {}
}

variable "route_tables" {
  type = map(object({
    name_override           = optional(string)
    resource_group_override = optional(string)
    subnets                 = list(string)
    routes = map(object({
      name_override          = optional(string)
      address_prefix         = string
      next_hop_type          = string
      next_hop_in_ip_address = optional(string)
    }))
  }))
  description = "Map of route tables to create."
  default     = {}
}

variable "network_security_groups" {
  type = map(object({
    name_override           = optional(string)
    resource_group_override = optional(string)
    subnets                 = optional(list(string))
    deny_inbound            = optional(bool, true)
    rules = map(object({
      name_override                              = optional(string)
      priority                                   = number
      direction                                  = string
      access                                     = string
      protocol                                   = string
      source_port_range                          = optional(string)
      source_port_ranges                         = optional(list(string))
      destination_port_range                     = optional(string)
      destination_port_ranges                    = optional(list(string))
      source_address_prefix                      = optional(string)
      source_address_prefixes                    = optional(list(string))
      source_application_security_group_ids      = optional(list(string))
      destination_address_prefix                 = optional(string)
      destination_address_prefixes               = optional(list(string))
      destination_application_security_group_ids = optional(list(string))
      description                                = optional(string)
    }))
  }))
  description = "Map of network security groups to create."
  default     = {}
}

variable "bgp_route_propagation_enabled" {
  default = true
}
