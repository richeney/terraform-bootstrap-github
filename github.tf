locals {
  workflow_templates = toset(var.github_create_workflows ? fileset("${path.module}/workflows", "*.ymltpl") : [])
  workflows          = toset([for template in local.workflow_templates : trimsuffix(template, "tpl")])
  workflow_template_vars = {
    runner_name                                  = "ubuntu-latest",
    backend_azure_storage_account_container_name = azurerm_storage_container.terraform.name
  }

  file_templates = toset(var.github_create_files ? fileset("${path.module}/files", "*.tftpl") : [])
  files          = toset([for template in local.file_templates : trimsuffix(template, "tpl")])
  file_template_vars = {
    subscription_id = var.subscription_id
  }
}

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

// Optional example workflows in the repository

resource "github_repository_file" "workflow" {
  for_each            = local.workflow_templates
  repository          = var.github_repo_name
  branch              = "main"
  file                = ".github/workflows/${trimsuffix(each.value, "tpl")}"
  overwrite_on_create = false

  content = templatefile("${path.module}/workflows/${each.value}", local.workflow_template_vars)
}

// Optional set of Terraform files in the repository

resource "github_repository_file" "terraform" {
  for_each = local.file_templates

  repository          = var.github_repo_name
  branch              = "main"
  file                = trimsuffix(each.value, "tpl")
  overwrite_on_create = false

  content = templatefile("${path.module}/files/${each.value}", local.file_template_vars)
}
