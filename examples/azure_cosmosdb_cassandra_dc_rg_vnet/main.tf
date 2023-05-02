## This module deploys a Azure Managed Instance Cassandra datacter cluster in a user provided resource group and vNET
#this is exampel for existing azure resource group and vnet
module "azure-acc-datacenter" {
  source                = "../../"
  acc_pswd              = var.acc_pswd
  resource_group_name   = "DS-MANAGED-CASS"
  acc_virtualnetwork    = "dscassandra_vnet"
  acc_virtualsubnet     = "dscassandra_sub1"
}