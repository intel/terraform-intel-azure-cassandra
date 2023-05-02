output "acc_rg_name" {
  description = "ACC Resource Group Name"
  value       = module.azure-acc-datacenter.acc_rg_name
}

output "acc_rg_location" {
  description = "ACC Resource Group Location"
  value       = module.azure-acc-datacenter.acc_rg_location
}

output "acc_vnet_name" {
  description = "ACC vNET Name"
  value       = module.azure-acc-datacenter.acc_vnet_name
}
output "acc_subnet_name" {
  description = "ACC Subnet Name"
  value       = module.azure-acc-datacenter.acc_subnet_name
}

output "acc_datacenter_sku" {
  description = "ACC Datacetner SKU"
  value       =  module.azure-acc-datacenter.acc_datacenter_sku
}
