########################
####     Intel      ####
########################

#Azure Managed Instance Apache Cassandra SKU
#The E-v5, and Lsv3-series run on the 3rd Generation Intel® Xeon® Platinum 8370C (Ice Lake), the Intel® Xeon® Platinum 8272CL (Cascade Lake) processors, or the Intel® Xeon® Platinum 8168 (Skylake) processors.
# For Azure Managed Instance Data Center SKU Size we recommend - Standard_D8s_v4m Standard_D16s_v4, Standard_D32s_v4, Standard_DS13_v2, Standard_DS14_v2, Standard_E8s_v4, Standard_E16s_v4, Standard_E20s_v4, Standard_E32s_v4
# Ex.: Standard_D8s_v4 -> 8 stands for vCPU count
# Azure Docs:  https://www.intel.com/content/www/us/en/partner/workload/microsoft/data-analytics-azure-lsv3-vs-lsv1-benchmark.html
# Azure Docs:  https://www.intel.com/content/www/us/en/partner/workload/microsoft/azure-dv4-vms-outperform-dv3-benchmark.html
# Azure Docs:  https://www.intel.com/content/www/us/en/partner/workload/microsoft/sql-analysis-127-faster-on-azure-benchmark.html
# Azure Docs:  https://www.intel.com/content/www/us/en/partner/workload/microsoft/msft-sql-server-snapshot.html
# Azure Docs:  https://www.intel.com/content/www/us/en/partner/workload/microsoft/sql-server-oltp-azure-esv5-benchmark.html

variable "acc_sku" {
description = "Instance SKU, see comments above for guidance"
  type        = string
  default     = "Standard_D8s_v4"
}

########################
####    Required    ####
########################

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