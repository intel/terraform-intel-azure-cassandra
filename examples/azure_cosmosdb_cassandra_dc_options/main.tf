#########################################################
# Local variables, modify for your needs                #
#########################################################
#These are required variable for creating a Azure Managed Instance Apache Cassandra Datacenter Cluster
locals {
  rg_name                     = "accexample-rg"
  rg_location                 = "East US"      
  vnet_name                   = "accexample-vnet"
  vnet_address_space          = "10.0.0.0/16"
  subnet_name                 = "accexample-subnet"
  subnet_address_prefixes     = "10.0.1.0/24"
  cass_version                = "4.0"
  acc_sku                     = "Standard_D8s_v4"
  node_count                  = 3
  disk_count                  = 4
  availability_zones_enabled  = false

  tags = {
    Owner    = "user@company.com"
    Duration = "24"
  }
}

resource "azurerm_resource_group" "ac_example" {
  name     = local.rg_name
  location = local.rg_location
}

resource "azurerm_virtual_network" "acc_example" {
  name                = local.vnet_name
  location            = local.rg_location
  resource_group_name = local.rg_name
  address_space       = [local.vnet_address_space]

}

resource "azurerm_subnet" "acc_example" {
  name                 = local.subnet_name
  resource_group_name  = local.rg_name
  virtual_network_name = local.vnet_name
  address_prefixes     = [local.subnet_address_prefixes]
}

data "azuread_service_principal" "acc_example" {
  display_name = "Azure Cosmos DB"
}

resource "azurerm_role_assignment" "acc_example" {
  scope                = azurerm_virtual_network.acc_example.id
  role_definition_name = "Network Contributor"
  principal_id         = data.azuread_service_principal.acc_example.object_id
}

resource "azurerm_cosmosdb_cassandra_cluster" "acc_example" {
  name                           = "accexample-cluster"
  resource_group_name            = local.rg_name
  location                       = local.rg_location
  delegated_management_subnet_id = azurerm_subnet.acc_example.id
  default_admin_password         = var.acc_pswd
  version                        = local.cass_version

  depends_on = [azurerm_role_assignment.acc_example]
}

resource "azurerm_cosmosdb_cassandra_datacenter" "acc_example" {
  name                           = "accexample-datacenter"
  location                       = local.rg_location
  cassandra_cluster_id           = azurerm_cosmosdb_cassandra_cluster.acc_example.id
  delegated_management_subnet_id = azurerm_subnet.acc_example.id
  node_count                     = local.node_count
  disk_count                     = local.disk_count
  sku_name                       = local.acc_sku
  availability_zones_enabled     = local.availability_zones_enabled
}