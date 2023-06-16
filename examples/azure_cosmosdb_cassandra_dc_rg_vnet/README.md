<p align="center">
  <img src="https://github.com/intel/terraform-intel-azure-cassandra/blob/main/images/logo-classicblue-800px.png?raw=true" alt="Intel Logo" width="250"/>
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

NOTE: Please be aware as of May 2023, there is a known discrepency between what is listed as supported SKU's in the Azure Managed Instance Apache Cassandra pricing documenation and what is actually supported in teh portal/cli: Azure Managed Instance Apache Cassandra price documentation indicates support for Ev5, Dv5 and Lv3 SKUs but on the Azure portal itself only Ev4, Dv4 and Dv3 are supported- this is also true for CLI. Thus, we have given approcximate gen-on-on improvements for benchmarks of similar database workloads below such as for MySQL and PostgreSQL on D-v4 and E-v4 series of Azure instances when compared to older generation D-v3 and E-v3 Azure instances.



<center>

#### [On MySQL™ Workloads, New Microsoft Azure Dv4 Virtual Machines with 2nd Gen Intel® Xeon® Scalable Processors Outperformed Dv3 VMs by up to 1.53x](https://www.intel.com/content/www/us/en/partner/workload/microsoft/azure-dv4-vms-outperform-dv3-benchmark.html)

<p align="center">
  <a href="https://www.intel.com/content/www/us/en/partner/workload/microsoft/azure-dv4-vms-outperform-dv3-benchmark.html">
  <img src="https://github.com/intel/terraform-intel-azure-cassandra/blob/main/images/mysql_dv4.png?raw=true" alt="Cassandra" width="600"/>
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

See examples folder for code ./examples/intel-optimized-postgresql-server/main.tf

Example of main.tf

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
