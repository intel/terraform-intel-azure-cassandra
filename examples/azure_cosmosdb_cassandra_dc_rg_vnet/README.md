<p align="center">
  <img src="./images/logo-classicblue-800px.png" alt="Intel Logo" width="250"/>
</p>

# Intel® Cloud Optimization Modules for Terraform

© Copyright 2022, Intel Corporation

## Azure Managed Instance for Apache Cassandra

 Module description

## Performance Data

Azure Managed Instance Apache Cassandra SKU
For Azure Managed Instance Data Center Supported Intel SKU are:
Standard_D16s_v4, Standard_D32s_v4, Standard_D8s_v4, Standard_DS12_v2, Standard_DS14_v2, Standard_E8s_v4, Standard_E16s_v4, Standard_E20s_V4, Standard_E32s_v4

DSv2-series sizes run on the 3rd Generation Intel® Xeon® Platinum 8370C (Ice Lake), Intel® Xeon® Platinum 8272CL (Cascade Lake), Intel® Xeon® 8171M 2.1GHz (Skylake) or the the Intel® Xeon® E5-2673 v4 2.3 GHz (Broadwell), or the Intel® Xeon® E5-2673 v3 2.4 GHz (Haswell) processors with Intel Turbo Boost Technology 2.0 and use premium storage.

The D-v4 and E-v4 series run on the 3rd Generation Intel® Xeon® Platinum 8370C (Ice Lake), the Intel® Xeon® Platinum 8272CL (Cascade Lake) processors, or the Intel® Xeon® Platinum 8168 (Skylake) processors.

NOTE: Please be aware as of May 2023, there is a known discrepency between what is listed as supported SKU's in the Azure Managed Instance Apache Cassandra pricing documenation and what is actually supported in teh portal/cli: Azure Managed Instance Apache Cassandra price documentation indicates support for Ev5, Dv5 and Lv3 SKUs but on the Azure portal itself only Ev4, Dv4 and Dv3 are supported- this is also true for CLI. 

## Usage

See examples folder for code ./examples/intel-optimized-postgresql-server/main.tf

Example of main.tf

```hcl
# Example of how to pass variable for database password:
# terraform apply -var="db_password=..."
# Environment variables can also be used https://www.terraform.io/language/values/variables#environment-variables

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

#Create the Managed Instance Apach Cassandra cluster
resource "azurerm_cosmosdb_cassandra_cluster" "acc_cluster" {
  name                           = "accexample-cluster"
  resource_group_name            = data.azurerm_resource_group.acc_rg.name
  location                       = data.azurerm_resource_group.acc_rg.location
  delegated_management_subnet_id = data.azurerm_subnet.acc_subnet.id
  default_admin_password         = var.acc_pswd
  version                        = var.version

  depends_on = [azurerm_role_assignment.acc_role]
}

#Create the Managed Instance Apache Cassandra Datacenter 
resource "azurerm_cosmosdb_cassandra_datacenter" "acc_datacenter" {
  name                           = "accexample-datacenter"
  location                       = data.azurerm_resource_group.acc_rg.location
  cassandra_cluster_id           = azurerm_cosmosdb_cassandra_cluster.acc_cluster.id
  delegated_management_subnet_id = data.azurerm_subnet.acc_subnet.id
  node_count                     = var.node_count
  disk_count                     = va.disk_count
  sku_name                       = var.acc_sku
  availability_zones_enabled     = var.availability_zones_enabled
}

# Provision Intel Cloud Optimization Module
module "module-example" {
  source = "github.com/intel/module-name"
}

```

Run Terraform

```hcl
terraform init  
terraform plan
terraform apply

```

Note that this example may create resources. Run `terraform destroy` when you don't need these resources anymore.

## Considerations  
This module example will take approx. 20+min to complete 
Make sure that the "Azure Cosmos DB" prinicpal has not already been assigned the "Network Contributor" role to the vnet as this will assign it