#For Azure Managed Instance Data Center Supported Intel SKU are:
#Standard_D16s_v4, Standard_D32s_v4, Standard_D8s_v4, Standard_DS12_v2, Standard_DS14_v2, Standard_E8s_v4, Standard_E16s_v4, Standard_E20s_V4, Standard_E32s_v4
#For further details refer to README.MD

variable "acc_sku" {
description = "Instance SKU, see comments above for guidance"
  type        = string
  default     = "Standard_D8s_v4"
}

########################
####    Required    ####
########################

variable "acc_pswd" {
  description = "Password for the master database user."
  type        = string
  sensitive   = true
  validation {
    condition     = length(var.acc_pswd) >= 8
    error_message = "The db_password value must be at least 8 characters in length."
  }
}