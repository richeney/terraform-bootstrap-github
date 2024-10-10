terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id

  features {
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
  }

  storage_use_azuread = true

  resource_provider_registrations = "core"

  resource_providers_to_register = [
    "Microsoft.KeyVault"
  ]
}

provider "github" {
  owner = var.github_owner_name
  token = var.github_personal_access_token
}
