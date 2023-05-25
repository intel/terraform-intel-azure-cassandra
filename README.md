<p align="center">
  <img src="https://github.com/intel/terraform-intel-azure-cassandra/images/logo-classicblue-800px.png" alt="Intel Logo" width="250"/>
</p>

# Intel® Cloud Optimization Modules for Terraform

© Copyright 2022, Intel Corporation

## Azure Managed Instance for Apache Cassandra

 Module description

## Performance Data

Azure Managed Instance Apache Cassandra SKU
For Azure Managed Instance Data Center Supported Intel SKU are:
Standard_D16s_v4, Standard_D32s_v4, Standard_D8s_v4, Standard_DS12_v2, Standard_DS14_v2, Standard_E8s_v4, Standard_E16s_v4, Standard_E20s_V4, Standard_E32s_v4

Dsv4-series sizes run on the 3rd Generation Intel® Xeon® Platinum 8370C (Ice Lake) or the Intel® Xeon® Platinum 8272CL (Cascade Lake). The Dv4-series sizes offer a combination of vCPU, memory and remote storage options for most production workloads. Dsv4-series VMs feature Intel® Hyper-Threading Technology. Remote Data disk storage is billed separately from virtual machines.

DSv2-series sizes run on the 3rd Generation Intel® Xeon® Platinum 8370C (Ice Lake), Intel® Xeon® Platinum 8272CL (Cascade Lake), Intel® Xeon® 8171M 2.1GHz (Skylake) or the the Intel® Xeon® E5-2673 v4 2.3 GHz (Broadwell), or the Intel® Xeon® E5-2673 v3 2.4 GHz (Haswell) processors with Intel Turbo Boost Technology 2.0 and use premium storage.

Esv4-series sizes run on the 3rd Generation Intel® Xeon® Platinum 8370C (Ice Lake) or the Intel® Xeon® Platinum 8272CL (Cascade Lake). The Esv4-series instances are ideal for memory-intensive enterprise applications. Evs4-series VMs feature Intel® Hyper-Threading Technology. Remote Data disk storage is billed separately from virtual machines.

NOTE: Please be aware as of May 2023, there is a known discrepency between what is listed as supported SKU's in the Azure Managed Instance Apache Cassandra pricing documenation and what is actually supported in teh portal/cli: Azure Managed Instance Apache Cassandra price documentation indicates support for Ev5, Dv5 and Lv3 SKUs but on the Azure portal itself only Ev4, Dv4 and Dv3 are supported- this is also true for CLI. Thus, we have given approcximate gen-on-on improvements for benchmarks of similar database workloads below such as for MySQL and PostgreSQL on D-v4 and E-v4 series of Azure instances when compared to older generation D-v3 and E-v3 Azure instances.



<center>

#### [On MySQL™ Workloads, New Microsoft Azure Dv4 Virtual Machines with 2nd Gen Intel® Xeon® Scalable Processors Outperformed Dv3 VMs by up to 1.53x](https://www.intel.com/content/www/us/en/partner/workload/microsoft/azure-dv4-vms-outperform-dv3-benchmark.html)

<p align="center">
  <a href="https://www.intel.com/content/www/us/en/partner/workload/microsoft/azure-dv4-vms-outperform-dv3-benchmark.html">
  <img src="https://github.com/intel/terraform-intel-azure-cassandra/images/mysql_dv4.png?raw=true" alt="Cassandra" width="600"/>
  </a>
</p>

#

#### [Get 1.53x More MySQL Performance by Selecting Newer Microsoft Azure Edv4 Virtual Machines Featuring 2nd Gen Intel Xeon Scalable Processors](https://www.intel.com/content/www/us/en/partner/workload/microsoft/mysql-performs-on-newer-azure-edv4-vms-benchmark.html)

<p align="center">
  <a href="https://www.intel.com/content/www/us/en/partner/workload/microsoft/mysql-performs-on-newer-azure-edv4-vms-benchmark.html">
  <img src="https://github.com/intel/terraform-intel-azure-cassandra/images/mysql_edv4.png?raw=true" alt="Cassandra" width="600"/>
  </a>
</p>

#### [Handle up to 1.36x More PostgreSQL Database Transactions on Microsoft® Azure® Ddsv4 Virtual Machines vs. Dsv3 VMs](https://www.intel.com/content/www/us/en/partner/workload/microsoft/more-postgresql-on-azure-ddsv4-vms-benchmark.html)

<p align="center">
  <a href="https://www.intel.com/content/www/us/en/partner/workload/microsoft/more-postgresql-on-azure-ddsv4-vms-benchmark.html">
  <img src="https://github.com/intel/terraform-intel-azure-cassandra/images/postgresql_ddsv4.png?raw=true" alt="Cassandra" width="600"/>
  </a>
</p>

</center>

## Usage

Example of main.tf

```hcl
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

# Provision Intel Cloud Optimization Module
module "module-example" {
  source = "github.com/intel/module-name"
}

**Usage Considerations**

<p>

* **Prerequisites:**

  1. Have an existing Azure Resource Group in the region you want to deploy the Azure Cassandra Datacenter 
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

More information regarding deploying Azure Managed Instance Apache Cassandra can be found here: [Azure Apache Cassandra] Datacenter(https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_cassandra_datacenter)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.3.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>3.52.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~>3.52.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_cosmosdb_cassandra_datacenter](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_cassandra_datacenter) | resource |


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acc_sku"></a> [acc\_sku](#input\_acc\_sku) | ACC Datacenter SKU, see comments above for guidance. | `string` | `"Standard_E8s_v4"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Existing Resource Group where Apache Cassandra Datacneter reosurce will be created. | `string` | n/a | yes |
| <a name="input_acc_virtualnetwork"></a> [acc\_virtualnetwork](#input\_acc\_virtualnetwork) | Virtual Network Name. It should already exist. | `string` | n/a | yes |
| <a name="input_acc_virtualsubnet"></a> [acc\_virtualsubnet](#input\_acc\_virtualsubnet) | Name of the  subnet in your virtual network for your Cassandra Managed Instance. It should already exist.| `string` | n/a | yes |
| <a name="input_acc_pswd"></a> [acc\_pswd](#input\_acc\_pswd) | "Password for the master database user. | `string` | n/a | yes |


## Outputs

| Name | Description |
|------|-------------|
| <a name="output_acc_rg_name"></a> [acc\_rg\_name](#output\acc\_rg\_name) | ACC RG Name |
| <a name="output_acc_rg_location"></a> [acc\_rg\_location](#output\_acc\_rg\_location) | ACC RG Location |
| <a name="output_acc_vnet_name"></a> [acc\_vnet\_name](#output\_acc\_vnet\_name) | ACC vNET Name |
| <a name="output_acc_subnet_name"></a> [acc\_subnet\_name](#output\_acc\_subnet\_name) | ACC Subnet Name |
| <a name="output_acc_datacenter_sku"></a> [acc\_datacenter\_sku](#output\_acc\_datacenter\_sku) | ACC Datacenter SKU |
| <a name="output_acc_cluster_id"></a> [acc\_cluster\_id](#output\_acc\_cluster\_id) | ACC Cluster ID |
<!-- END_TF_DOCS -->