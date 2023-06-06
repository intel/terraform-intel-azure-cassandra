########################
####     Intel      ####
########################

#Azure Managed Instance Apache Cassandra SKU
#The D-v4 and E-v4 series run on the 3rd Generation Intel® Xeon® Platinum 8370C (Ice Lake), the Intel® Xeon® Platinum 8272CL (Cascade Lake) processors, or the Intel® Xeon® Platinum 8168 (Skylake) processors.

#For Azure Managed Instance Data Center Supported Intel SKU are:
#Standard_D16s_v4, Standard_D32s_v4, Standard_D8s_v4, Standard_DS12_v2, Standard_DS14_v2, Standard_E8s_v4, Standard_E16s_v4, Standard_E20s_V4, Standard_E32s_v4
#For further details refer to README.MD

variable "acc_sku" {
description = "Instance SKU, see comments above for guidance"
  type        = string
  default     = "Standard_E8s_v4"
}


variable "enable_intel_tags" {
  type    = bool
    default = true
  description = "If true adds additional Intel tags to resources"
}
variable "tags" {
  default     = {}
  type        = map(string)
  description = "A mapping of tags to assign to all resources."
}
variable "intel_tags" {
  default     = {
    intel-registry = "https://registry.terraform.io/namespaces/intel"
    intel-module   = "terraform-intel-azure-cassandra"
  }
  type        = map(string)
  description = "Intel Tags"
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
  description = "Virtual Network Name. It should already exist"
  type        = string
}

#Subnet Name
variable "acc_virtualsubnet" {
  description = "Name of the  subnet in your virtual network for your Cassandra Managed Instance. It should already exist"
  type        = string
}

#Cassandra cluster admin password. Do not commit password to version control systems 
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
#Cassandra cluster version (option is 3.11 or 4.0)
variable "acc_version"  {
  description = "The version of Apache Cassandra"
   default    = "4.0"
}

#Cassandra cluster Availablity Zone 
variable "availability_zones_enabled"  {
  description = "Cassandra cluster Availablity Zone "
   default    = "false"
}
  
#Cassandra cluster Node Count
variable "node_count"  {
  description = "Cassandra cluster Node Count "
   default    = "3"
}

#Cassandra cluster Disk Count
variable "disk_count"  {
  description = "Cassandra cluster Disk Count "
   default    = "4"
}

#Managed Disk Custome Key URI
variable "managed_disk_customer_key_uri" {
description = "The key URI of the customer key to use for the encryption of the Managed Disk."
default     = null
}

# Hours between backups
variable "hours_between_backups" {
  description = "Hours between backups"
  default     = 0
}