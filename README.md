<p align="center">
  <img src="https://github.com/intel/terraform-intel-azure-cassandra/blob/main/images/logo-classicblue-800px.png" alt="Intel Logo" width="250"/>
</p>

# Intel® Cloud Optimization Modules for Terraform

© Copyright 2022, Intel Corporation

## Azure Managed Instance for Apache Cassandra

**Please see ["Considerations"](https://github.com/intel/terraform-intel-azure-cassandra#considerations) section below for important information**

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
  <img src="https://github.com/intel/terraform-intel-azure-cassandra/blob/main/images/mysql_edv4.png?raw=true" alt="Cassandra" width="600"/>
  </a>
</p>

#### [Handle up to 1.36x More PostgreSQL Database Transactions on Microsoft® Azure® Ddsv4 Virtual Machines vs. Dsv3 VMs](https://www.intel.com/content/www/us/en/partner/workload/microsoft/more-postgresql-on-azure-ddsv4-vms-benchmark.html)

<p align="center">
  <a href="https://www.intel.com/content/www/us/en/partner/workload/microsoft/more-postgresql-on-azure-ddsv4-vms-benchmark.html">
  <img src="https://github.com/intel/terraform-intel-azure-cassandra/blob/main/images/postgresql_ddsv4.png?raw=true" alt="Cassandra" width="600"/>
  </a>
</p>

</center>

## Usage

Example of main.tf (located in the examples sub-folder)

```hcl
## This module deploys a Azure Managed Instance Cassandra datacter cluster in a user provided resource group, an existing vNET and an Subnet
#this is exampel for existing azure resource group and vnet
module "azure-acc-datacenter" {
  source                = "intel/azure-cassandra/intel"
  acc_pswd              = var.acc_pswd
  resource_group_name   = "DS-MANAGED-CASS"
  acc_virtualnetwork    = "dscassandra_vnet"
  acc_virtualsubnet     = "dscassandra_sub1"

    tags = {
    Owner    = "user@company.com"
    Duration = "24"
  }
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

**THREE IMPORTANT CONSIDERATIONS**


1. When using a **Service Principal**, it will require  ``` Application.Read.All ``` or ``` Directory.Read.All ``` Azure AD API permissions [see provider docs here](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/service_principal#:~:text=When%20authenticated%20with%20a%20service%20principal%2C%20this%20data%20source%20requires%20one%20of%20the%20following%20application%20roles%3A%20Application.Read.All%20or%20Directory.Read.All)
2. Make sure the  ``` Azure Cosmos DB ``` Azure AD application has not already been assigned the ``` Network Contributor ``` role to the vnet as this will assign it
3. It takes 15-30 minutes for the Cassandra Cluster to be created and ready for use




More information regarding deploying Azure Managed Instance Apache Cassandra can be found here: [Azure Apache Cassandra Datacenter](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_cassandra_datacenter)

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
