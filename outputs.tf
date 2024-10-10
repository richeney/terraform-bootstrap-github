output "tenant_id" {
  value = data.azurerm_subscription.terraform.tenant_id
}

output "subscription_id" {
  value = var.subscription_id
}

output "client_id" {
  value = azurerm_user_assigned_identity.terraform.client_id
}

output "storage_account_name" {
  value = azurerm_storage_account.terraform.name
}

output "storage_account_id" {
  value = azurerm_storage_account.terraform.id
}

output "github_actions_variables_url" {
  value = "https://github.com/${var.github_owner_name}/${var.github_repo_name}/settings/variables/actions"
}

output "federated_credentials_url" {
  value = "https://portal.azure.com/#@${data.azurerm_subscription.terraform.tenant_id}/resource${azurerm_user_assigned_identity.terraform.id}/federatedcredentials"
}

output "managed_identity_rbac_url" {
  value = "https://portal.azure.com/#@${data.azurerm_subscription.terraform.tenant_id}/resource${azurerm_user_assigned_identity.terraform.id}/azure_resources"
}
