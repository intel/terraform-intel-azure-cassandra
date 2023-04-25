########################
####     Intel      ####
########################

#Azure Managed Instance Apache Cassandra SKU
#The E-v5, and Lsv3-series run on the 3rd Generation Intel® Xeon® Platinum 8370C (Ice Lake), the Intel® Xeon® Platinum 8272CL (Cascade Lake) processors, or the Intel® Xeon® Platinum 8168 (Skylake) processors.
# For Azure Managed Instance Data Center SKU Size we recommend: Standard_D8s_v4m, Standard_D16s_v4, Standard_D32s_v4, Standard_DS13_v2, Standard_DS14_v2, Standard_E8s_v4, Standard_E16s_v4, Standard_E20s_v4, Standard_E32s_v4
# Ex.: Standard_D8s_v4 -> 8 stands for vCPU count
# Azure Docs:  https://www.principledtechnologies.com/intel/Lsv3-VMs-Apache-Cassandra-competitive-0822.pdf
# Azure Docs:  https://www.intel.com/content/www/us/en/content-details/754441/experience-up-to-1-12x-the-apache-cassandra-database-performance-by-choosing-microsoft-azure-lsv3-virtual-machines-over-lasv3-vms.html



variable "acc_sku" {
description = "Instance SKU, see comments above for guidance"
  type        = string
  default     = "Standard_D8s_v4"
}

########################
####    Required    ####
########################
#Resource group name
variable "resource_group_name" {
  description = "Resource Group where resource will be created. It should already exist"
  type        = string
}

#Vnet Name
variable "acc_virtualnetwork" {
  description = "Virtual Netowrk Name. It should already exist"
  type        = string
   default     = ""
}

variable "acc_virtualsubnet" {
  description = "Name of the  subnet in your virtual network for your Cassandra Managed Instance. It should already exist"
  type        = string
  default     = ""
}

#Cassandra cluser admin password. Do not commit password to version control systems 
variable "acc_pswd" {
  description = "Password for the master database user."
  type        = string
  sensitive   = true
  validation {
    condition     = length(var.acc_pswd) >= 8
    error_message = "The db_password value must be at least 8 characters in length."
  }
}

########################
####     Other      ####
########################