locals {
  #If the enable_intel_tags is true, then additional Intel tags will be added to the resources created
  tags = var.enable_intel_tags ? merge(var.intel_tags, var.tags) : var.tags
}

#Use the existing azure resource group for Managed Instance Apache Cassandra Datacenter cluster
data "azurerm_resource_group" "acc_rg" {
  name = var.resource_group_name
}

#Use the existing azure virtual network for Managed Instance Apache Cassandra Datacenter cluster
data "azurerm_virtual_network" "acc_vnet" {
  name                = var.acc_virtualnetwork
  #location            = data.azurerm_resource_group.acc_rg.location
  resource_group_name = data.azurerm_resource_group.acc_rg.name
  #address_space       = data.azurerm_virtual_network.acc_vnet.address_space
}

#Use the existing azure virtual network subnet for Managed Instance Apache Cassandra Datacenter cluster
data "azurerm_subnet" "acc_subnet" {
  name                 = var.acc_virtualsubnet
  resource_group_name  = data.azurerm_resource_group.acc_rg.name
  virtual_network_name = data.azurerm_virtual_network.acc_vnet.name
  #address_prefixes     = data.azurerm_subnet.acc_subnet.address_prefixes
}

#Use the logged-in Azure AD service principal for granting access to the Azuzre Cosmos DB for Managed Instance Apache Cassandra Datacenter cluster
data "azuread_service_principal" "acc_principal" {
  display_name = "Azure Cosmos DB"
}
#Assign the logged-in prinicpal with the network contributor role for Managed Instance Apache Cassandra Datacenter cluster
resource "azurerm_role_assignment" "acc_role" {
  scope                = data.azurerm_virtual_network.acc_vnet.id
  role_definition_name = "Network Contributor"
  principal_id         = data.azuread_service_principal.acc_principal.object_id
}

#Random ID
resource "random_id" "rid" {
  byte_length = 5
}

#Create the Managed Instance Apach Cassandra cluster
resource "azurerm_cosmosdb_cassandra_cluster" "acc_cluster" {
  name                           = "accexample-cluster-${random_id.rid.dec}"
  resource_group_name            = data.azurerm_resource_group.acc_rg.name
  location                       = data.azurerm_resource_group.acc_rg.location
  delegated_management_subnet_id = data.azurerm_subnet.acc_subnet.id
  default_admin_password         = var.acc_pswd
  version                        = var.acc_version

  depends_on = [azurerm_role_assignment.acc_role]
  tags = local.tags
}

#Create the Managed Instance Apache Cassandra Datacenter 
##You can sepcify Intel Recommended SKU- (See README.MD for details) the default is Standard_D8s_v5
resource "azurerm_cosmosdb_cassandra_datacenter" "acc_datacenter" {
  name                           = "accexample-datacenter-${random_id.rid.dec}"
  location                       = data.azurerm_resource_group.acc_rg.location
  cassandra_cluster_id           = azurerm_cosmosdb_cassandra_cluster.acc_cluster.id
  delegated_management_subnet_id = data.azurerm_subnet.acc_subnet.id
  node_count                     = var.node_count
  disk_count                     = var.disk_count
  sku_name                       = var.acc_sku
  availability_zones_enabled     = var.availability_zones_enabled
  managed_disk_customer_key_uri  = var.managed_disk_customer_key_uri
 }