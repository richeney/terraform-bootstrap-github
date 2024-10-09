terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = ">= 6.0"
    }
  }
}

terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

provider "github" {
  owner = var.github_owner_name
  token = var.github_personal_access_token
}
