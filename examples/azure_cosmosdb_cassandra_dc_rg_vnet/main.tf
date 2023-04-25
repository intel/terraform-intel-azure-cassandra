#this is exampel for existing azure resource group and vnet
data "azurerm_resource_group" "acc_rg" {
  name = var.resource_group_name
}

data "azurerm_virtual_network" "acc_vnet" {
  name                = var.acc_virtualnetwork
  #location            = data.azurerm_resource_group.acc_rg.location
  resource_group_name = data.azurerm_resource_group.acc_rg.name
  #address_space       = data.azurerm_virtual_network.acc_vnet.address_space
}

data "azurerm_subnet" "acc_subnet" {
  name                 = var.acc_virtualsubnet
  resource_group_name  = data.azurerm_resource_group.acc_rg.name
  virtual_network_name = data.azurerm_virtual_network.acc_vnet.name
  #address_prefixes     = data.azurerm_subnet.acc_subnet.address_prefixes
}

data "azuread_service_principal" "acc_principal" {
  display_name = "Azure Cosmos DB"
}

resource "azurerm_role_assignment" "acc_role" {
  scope                = data.azurerm_virtual_network.acc_vnet.id
  role_definition_name = "Network Contributor"
  principal_id         = data.azuread_service_principal.acc_principal.object_id
}

resource "azurerm_cosmosdb_cassandra_cluster" "acc_cluster" {
  name                           = "accexample-cluster"
  resource_group_name            = data.azurerm_resource_group.acc_rg.name
  location                       = data.azurerm_resource_group.acc_rg.location
  delegated_management_subnet_id = data.azurerm_subnet.acc_subnet.id
  default_admin_password         = var.acc_pswd
  version                        = "4.0"

  depends_on = [azurerm_role_assignment.acc_role]
}

resource "azurerm_cosmosdb_cassandra_datacenter" "acc_datacenter" {
  name                           = "accexample-datacenter"
  location                       = data.azurerm_resource_group.acc_rg.location
  cassandra_cluster_id           = azurerm_cosmosdb_cassandra_cluster.acc_cluster.id
  delegated_management_subnet_id = data.azurerm_subnet.acc_subnet.id
  node_count                     = 3
  disk_count                     = 4
  sku_name                       = var.acc_sku
  availability_zones_enabled     = false
}