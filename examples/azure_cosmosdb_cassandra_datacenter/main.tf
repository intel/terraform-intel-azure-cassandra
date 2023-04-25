resource "azurerm_resource_group" "acc_example" {
  name     = "accexample-rg"
  location = "East US"
}

resource "azurerm_virtual_network" "acc_example" {
  name                = "accexample-vnet"
  location            = azurerm_resource_group.acc_example.location
  resource_group_name = azurerm_resource_group.acc_example.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "acc_example" {
  name                 = "accexample-subnet"
  resource_group_name  = azurerm_resource_group.acc_example.name
  virtual_network_name = azurerm_virtual_network.acc_example.name
  address_prefixes     = ["10.0.1.0/24"]
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
  resource_group_name            = azurerm_resource_group.acc_example.name
  location                       = azurerm_resource_group.acc_example.location
  delegated_management_subnet_id = azurerm_subnet.acc_example.id
  default_admin_password         = var.acc_pswd
  version                        = "4.0"

  depends_on = [azurerm_role_assignment.acc_example]
}

resource "azurerm_cosmosdb_cassandra_datacenter" "acc_example" {
  name                           = "accexample-datacenter"
  location                       = azurerm_cosmosdb_cassandra_cluster.acc_example.location
  cassandra_cluster_id           = azurerm_cosmosdb_cassandra_cluster.acc_example.id
  delegated_management_subnet_id = azurerm_subnet.acc_example.id
  node_count                     = 3
  disk_count                     = 4
  sku_name                       = var.acc_sku
  availability_zones_enabled     = false
}