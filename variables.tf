variable "github_owner_name" {
  description = "The name of the GitHub owner or organization."
  type        = string
}

variable "github_repo_name" {
  description = "The name of the GitHub repository."
  type        = string
}

variable "github_personal_access_token" {
  description = "Value of the GitHub fine grained personal access token"
  type        = string
}

variable "tenant_id" {
  type        = string
  description = "The Entra ID tenant GUID. Defaults to current context if unset."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group to deploy resources."
}

variable "subscription_id" {
  type        = string
  description = "The subscription guid for the terraform workload identity and remote state."
}

variable "storage_account_name" {
  type        = string
  description = "The name of the storage account for terraform state."
}

variable "storage_container_name" {
  type        = string
  description = "The name of the storage container for terraform state."
}

variable "client_id" {
  type        = string
  description = "The client id of the managed identity."
}

variable "managed_identity_id" {
  description = "The id of the managed identity."
  type        = string
}

variable "github_create_pipeline" {
  description = "Create a pipeline in GitHub."
  type        = bool
  default     = false
}