<p align="center">
  <img src="./images/logo-classicblue-800px.png" alt="Intel Logo" width="250"/>
</p>

# Intel® Cloud Optimization Modules for Terraform

© Copyright 2022, Intel Corporation

## Azure Managed Instance for Apache Cassandra

 Module description

## Performance Data

#Azure Managed Instance Apache Cassandra SKU

The E-v5, and Lsv3-series run on the 3rd Generation Intel® Xeon® Platinum 8370C (Ice Lake), the Intel® Xeon® Platinum 8272CL (Cascade Lake) processors, or the Intel® Xeon® Platinum 8168 (Skylake) processors.

For Azure Managed Instance Data Center SKU Size we recommend: 
Standard_D8s_v4m, Standard_D16s_v4, Standard_D32s_v4, Standard_DS13_v2, Standard_DS14_v2
Standard_E8s_v4, Standard_E16s_v4, Standard_E20s_v4, Standard_E32s_v4

Ex.: Standard_D8s_v4 -> 8 stands for vCPU count


<center>

#### [Complete more Apache Cassandra database work with Microsoft Azure Lsv3-series VMs enabled by 3rd Gen Intel® Xeon® Scalable processors](https://www.principledtechnologies.com/intel/Lsv3-VMs-Apache-Cassandra-competitive-0822.pdf)

<p align="center">
  <a href="https://www.principledtechnologies.com/intel/Lsv3-VMs-Apache-Cassandra-competitive-0822.pdf">
  <img src="./images/azure_lsv3_casssandra.png?raw=true" alt="Cassandra" width="600"/>
  </a>
</p>

#

#### [Experience up to 1.12x the Apache Cassandra Database Performance by Choosing Microsoft Azure Lsv3 Virtual Machines over Lasv3 VMs](https://www.principledtechnologies.com/intel/Lsv3-VMs-Apache-Cassandra-competitive-0822.pdf)

<p align="center">
  <a href="https://www.principledtechnologies.com/intel/Lsv3-VMs-Apache-Cassandra-competitive-0822.pdf">
  <img src="./images/azure_lsv3_casssandra_smlvms.png?raw=true" alt="Cassandra" width="600"/>
  </a>
</p>

</center>

## Usage

See examples folder for code ./examples/intel-optimized-postgresql-server/main.tf

Example of main.tf

```hcl
# Example of how to pass variable for database password:
# terraform apply -var="db_password=..."
# Environment variables can also be used https://www.terraform.io/language/values/variables#environment-variables

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
NOTE: This module example will take approx. 20+min to complete 