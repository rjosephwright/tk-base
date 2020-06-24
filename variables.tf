variable "billing_id" {
  type         = string
  description  = "ID of billing account to associate with projects."
}

variable "folder_admin_roles" {
  type         = list(string)
  description  = "Roles assigned to folder admins, if defined."
  default      = []
}

variable "folder_admins" {
  type         = list(string)
  description  = "Optional member names of folder admins."
  default      = []
}

variable "parent_folder_id" {
  type         = string
  description  = "ID of parent folder in which dedicated test folder will be created."
}

variable "organization_id" {
  type         = string
  description  = "ID of organization."
}

variable "name" {
  type         = string
  description  = "Base name given to resources in module."
}
