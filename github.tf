resource "github_actions_variable" "github" {
  for_each = {
    "ARM_TENANT_ID"                                = data.azurerm_subscription.terraform.tenant_id,
    "ARM_SUBSCRIPTION_ID"                          = var.subscription_id,
    "ARM_CLIENT_ID"                                = azurerm_user_assigned_identity.terraform.client_id,
    "BACKEND_AZURE_RESOURCE_GROUP_NAME"            = azurerm_resource_group.terraform.name,
    "BACKEND_AZURE_STORAGE_ACCOUNT_NAME"           = azurerm_storage_account.terraform.name,
    "BACKEND_AZURE_STORAGE_ACCOUNT_CONTAINER_NAME" = azurerm_storage_container.terraform.name
  }

  repository    = var.github_repo_name
  variable_name = each.key
  value         = each.value
}

resource "azurerm_federated_identity_credential" "github" {
  name                = replace(var.github_repo_name, "-", "_")
  resource_group_name = azurerm_user_assigned_identity.terraform.resource_group_name
  parent_id           = azurerm_user_assigned_identity.terraform.id

  audience = ["api://AzureADTokenExchange"]
  issuer   = "https://token.actions.githubusercontent.com"
  subject  = "repo:${var.github_owner_name}/${var.github_repo_name}:ref:refs/heads/main"
}

//Github Repository Files

/*
Needs testing - this is a placeholder for creating a GitHub Actions pipeline
resource "github_repository_file" "pipeline" {
  for_each            = local.github && var.github_create_pipeline ? ["terraform.yml"] : []
  repository          = var.github_repo_name
  branch              = "main"
  file                = ".gihub/workflows/terraform.yml"
  overwrite_on_create = false

  content = file("${path.module}/templates/github_pipeline.tftpl")
}
*/

/*
// Placeholder - create tfvars and perhaps a default set of Terraform files in the repository
resource "github_repository_file" "tfvars" {
  for_each            = local.github && var.github_create_pipeline ? ["terraform.yml"] : []
  repository          = var.github_repo_name
  branch              = "main"
  file                = "terraform/bootstrap.auto.tfvars"
  overwrite_on_create = true

  content = <<-EOF
  subscription_id               = "${var.subscription_id}"
  resource_group_name           = "${azurerm_resource_group.terraform.name}"
  storage_account_name          = "${azurerm_storage_account.terraform.name}"
  location                      = "${var.location}"

  tags = ${jsonencode(var.tags != null ? var.tags : {})}
  EOF
}
*/
