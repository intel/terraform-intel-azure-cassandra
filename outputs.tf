output "acc_rg_name" {
  description = "ACC Resource Group Name"
  value       = data.azurerm_resource_group.acc_rg.name
}

output "acc_rg_location" {
  description = "ACC Resource Group Location"
  value       = data.azurerm_resource_group.acc_rg.location
}

output "acc_vnet_name" {
  description = "ACC vNET Name"
  value       = data.azurerm_virtual_network.acc_vnet.name
}
output "acc_subnet_name" {
  description = "ACC Subnet Name"
  value       = data.azurerm_subnet.acc_subnet.name
}

output "acc_datacenter_sku" {
  description = "ACC Datacetner SKU"
  value       =  azurerm_cosmosdb_cassandra_datacenter.acc_datacenter.sku_name
}

output "acc_cluster_id" {
  description = "ACC Cluster ID"
  value       =  azurerm_cosmosdb_cassandra_datacenter.acc_datacenter.cassandra_cluster_id
}