output "client_id" {
  value = azurerm_user_assigned_identity.terraform.client_id
}

output "storage_account_name" {
  value = azurerm_storage_account.terraform.name
}

output "subscription_id" {
  value = var.subscription_id
}

output "tenant_id" {
  value = data.azurerm_subscription.terraform.tenant_id
}

output "url_azure" {
  value = "https://portal.azure.com/#@${data.azurerm_subscription.terraform.tenant_id}/resource${azurerm_resource_group.terraform.id}"
}

output "url_github" {
  value = "https://github.com/${var.github_owner_name}/${var.github_repo_name}"
}
