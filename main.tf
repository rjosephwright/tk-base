locals {
  role_billing_user                           = "roles/billing.user"
  role_resource_manager_project_creator       = "roles/resourcemanager.projectCreator"
  activated_apis                              = [
    "cloudbilling.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "serviceusage.googleapis.com",
  ]
}

module "host_project" {
  source                                      = "terraform-google-modules/project-factory/google"
  version                                     = "= 8.0.1"

  name                                        = "${var.name}-host"
  default_service_account                     = "delete"
  random_project_id                           = "true"
  org_id                                      = var.organization_id
  billing_account                             = var.billing_id
  activate_apis                               = local.activated_apis
}

module "service_account" {
  source                                      = "terraform-google-modules/service-accounts/google"
  version                                     = "= 3.0.0"

  project_id                                  = module.host_project.project_id
  names                                       = ["${var.name}-owner"]
}

module "ci_folder" {
  source                                      = "terraform-google-modules/folders/google"
  version                                     = "= 2.0.2"

  parent                                      = "folders/${var.parent_folder_id}"
  names                                       = [var.name]
  set_roles                                   = length(var.folder_admins) > 0
  folder_admin_roles                          = length(var.folder_admin_roles) > 0 ? var.folder_admin_roles : null
  all_folder_admins                           = length(var.folder_admins) > 0 ? var.folder_admins : null
}

resource "google_folder_iam_member" "ci_folder_iam_binding" {
  folder                                      = module.ci_folder.id
  role                                        = local.role_resource_manager_project_creator
  member                                      = "serviceAccount:${module.service_account.email}"
}

resource "google_organization_iam_member" "organization_iam_binding" {
  org_id                                      = var.organization_id
  role                                        = local.role_billing_user
  member                                      = "serviceAccount:${module.service_account.email}"
}
