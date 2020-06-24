output "billing_id" {
  value = var.billing_id
}

output "folder_id" {
  value = module.ci_folder.id
}

output "host_project_id" {
  value = module.host_project.project_id
}

output "organization_id" {
  value = var.organization_id
}

output "service_account_email" {
  value = module.service_account.email
}
