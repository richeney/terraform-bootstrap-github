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

// Optional pipeline file in the repository

resource "github_repository_file" "pipeline" {
  for_each            = toset(var.github_create_pipeline ? ["terraform.yml"] : [])
  repository          = var.github_repo_name
  branch              = "main"
  file                = ".github/workflows/terraform.yml"
  overwrite_on_create = false

  content = templatefile("${path.module}/workflows/terraform.ymltpl", {
    runner_name                                  = "ubuntu-latest",
    backend_azure_storage_account_container_name = azurerm_storage_container.terraform.name
  })
}

// Optional set of Terraform files in the repository - shame there is no equivalent of template_dir

resource "github_repository_file" "terraform" {
  for_each = var.github_create_files ? {
    "main.tf" : {
      source = "files/main.tftpl"
      vars   = { subscription_id = var.subscription_id }
    },
    "provider.tf" : {
      source = "files/provider.tftpl"
      vars   = {}
    },

  } : {}

  repository          = var.github_repo_name
  branch              = "main"
  file                = each.key
  overwrite_on_create = false

  content = templatefile("${path.module}/${each.value.source}", each.value.vars)
}
