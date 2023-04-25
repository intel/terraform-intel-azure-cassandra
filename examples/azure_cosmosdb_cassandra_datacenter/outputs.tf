output "acc_rg_name" {
  description = "ACC Resource Group Name"
  value       = azurerm_resource_group.acc_example.name
}

output "acc_rg_location" {
  description = "ACC Resource Group Name"
  value       = azurerm_resource_group.acc_example.location
}

output "acc_vnet_name" {
  description = "ACC vNET Name"
  value       = azurerm_virtual_network.acc_example.name
}
output "acc_subnet_name" {
  description = "ACC Subnet Name"
  value       = azurerm_subnet.acc_example.name
}

output "acc_datacenter_sku" {
  description = "ACC Datacetner SKU"
  value       =  azurerm_cosmosdb_cassandra_datacenter.acc_example.sku_name
}