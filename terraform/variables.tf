variable "resource_group_name" {
  type        = string
  description = "Naam van de bestaande Azure Resource Group"
}

variable "location" {
  type        = string
  default     = "westeurope"
  description = "Azure regio voor deployment"
}

variable "ssh_public_key_path" {
  type        = string
  description = "~/home/student/azure.pub"
}

variable "vm_count" {
  type        = number
  default     = 2
  description = "Aantal VM's dat moet worden aangemaakt"
}

variable "vm_admin_username" {
  type        = string
  default     = "iac"
  description = "De standaard admin user op de VM"
}
