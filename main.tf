#Use the existing azure resource group for Managed Instance Cassandra Datacenter cluster
data "azurerm_resource_group" "acc_rg" {
  name = var.resource_group_name
}

#Use the existing azure virtual network for Managed Instance Cassandra Datacenter cluster
data "azurerm_virtual_network" "acc_vnet" {
  name                = var.acc_virtualnetwork
  #location            = data.azurerm_resource_group.acc_rg.location
  resource_group_name = data.azurerm_resource_group.acc_rg.name
  #address_space       = data.azurerm_virtual_network.acc_vnet.address_space
}

#Use the existing azure virtual network subnet for Managed Instance Cassandra Datacenter cluster
data "azurerm_subnet" "acc_subnet" {
  name                 = var.acc_virtualsubnet
  resource_group_name  = data.azurerm_resource_group.acc_rg.name
  virtual_network_name = data.azurerm_virtual_network.acc_vnet.name
  #address_prefixes     = data.azurerm_subnet.acc_subnet.address_prefixes
}

#Use the logged-in Azure AD service principal for granting access to the Azuzre Cosmos DB for Managed Instance Cassandra Datacenter cluster
data "azuread_service_principal" "acc_principal" {
  display_name = "Azure Cosmos DB"
}
#Assign the logged-in prinicpal with the network contributor role for Managed Instance Cassandra Datacenter cluster
resource "azurerm_role_assignment" "acc_role" {
  scope                = data.azurerm_virtual_network.acc_vnet.id
  role_definition_name = "Network Contributor"
  principal_id         = data.azuread_service_principal.acc_principal.object_id
}

#Create the Managed Instance Cassandra cluster
resource "azurerm_cosmosdb_cassandra_cluster" "acc_cluster" {
  name                           = "accexample-cluster"
  resource_group_name            = data.azurerm_resource_group.acc_rg.name
  location                       = data.azurerm_resource_group.acc_rg.location
  delegated_management_subnet_id = data.azurerm_subnet.acc_subnet.id
  default_admin_password         = var.acc_pswd
  version                        = "4.0"

  depends_on = [azurerm_role_assignment.acc_role]
}

#Create the Managed Instance Cassandra Datacenter 
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