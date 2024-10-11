
variable "subscription_id" {
  type        = string
  description = "The subscription guid for the terraform workload identity and remote state."

  validation {
    condition     = length(var.subscription_id) == 36 && can(regex("^[a-z0-9-]+$", var.subscription_id))
    error_message = "Subscription ID must be a 36 character GUID."
  }
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group to deploy resources."
  default     = "terraform"
}

variable "location" {
  type        = string
  description = "The Azure region to deploy resources."
  default     = "UK South"
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to add to resources."
  default     = null
}

variable "managed_identity_name" {
  type        = string
  description = "The name of the managed identity."
  default     = "terraform"
}

variable "storage_account_name" {
  type        = string
  description = "The name of the storage account. Must be globally unique."
  default     = null

  validation {
    condition     = var.storage_account_name == null ? true : (length(coalesce(var.storage_account_name, "abcefghijklmnopqrstuwxy")) <= 24 && length(coalesce(var.storage_account_name, "ab")) > 3 && can(regex("^[a-z0-9]+$", coalesce(var.storage_account_name, "A%"))))
    error_message = "Storage account name must be null or 3-24 of lowercase alphanumerical characters, and globally unique"
  }
}

//================================================================

variable "github_owner_name" {
  description = "The name of the GitHub owner or organization."
  type        = string

  validation {
    condition     = length(var.github_owner_name) > 0
    error_message = "The github_owner_name must be a valid string."
  }
}

variable "github_repo_name" {
  description = "The name of the GitHub repository."
  type        = string

  validation {
    condition     = length(var.github_repo_name) > 0
    error_message = "The github_repo_name must be a valid string."
  }

}

variable "github_personal_access_token" {
  description = "Value of the GitHub fine grained personal access token"
  type        = string

  validation {
    condition     = length(var.github_personal_access_token) > 0
    error_message = "The github_pat_value must be a valid string."
  }
}

variable "github_create_pipeline" {
  description = "Create a pipeline in GitHub."
  type        = bool
  default     = true
}

variable "github_create_files" {
  description = "Create a set of Terraform files in GitHub."
  type        = bool
  default     = true
}
