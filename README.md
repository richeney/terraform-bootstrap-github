# Terraform  Bootstrap

Example bootstrap for both Azure DevOps and GitHub Actions using federated workload identities.

## Create a new repo

1. Go to <https://github.com>
1. Click on **+, New repository**
1. Enter repo name and description
1. Select visibility
1. Add a README and a Terraform .gitignore
1. Select a licence - I use MIT

Recommended - set up a template with a default minimal config to accelerate testing.

## Create a personal access token

This is short-lived and is only needed for the duration of the bootstrap itself. Once the bootstrap is completed then you may revoke the token.

1. Click on your profile at the top right > Settings
1. Developer settings > Personal access tokens > Fine-grained tokens
1. Generate new token (prompts MFA auth)
1. Set token name, e.g. the same as the repo
1. Select repo(s)
1. Set repo permissions to Read and write for:
    - Actions
    - Contents
    - Variables
1. Generate token
1. Copy the token value somewhere safe

## Create a terraform.tfvars

Example file:

```shell
subscription_id = "abcdef01-2345-6789-abcd-314159265359"

github_owner_name            = "richeney"
github_repo_name             = "terraform-bootstrap-github-test"
github_personal_access_token = "paste_your_github_token_here"
github_create_workflows      = true
github_create_files          = true
```

Note that you can also use an organization name as the value for github_owner_name. Additional variables may be found in variables.tf.

## Bootstrap

Run the bootstrap in your shell.

1. Initialise

    ```shell
    terraform init
    ```

1. Apply

    ```shell
    terraform apply
    ```

This will create the resources. The bootstrap is a one off and therefore the local terraform.tfstate state file is not intended to be preserved for lifecycle management.

## Post bootstrap

Follow the link in the outputs to see the resource group with the newly created Azure resources. Check the identity's RBAC assignments and federated credential.

Follow the link in the outputs to check the repo's GitHub Actions variables and workflows.

You can now use the provided plan and apply workflows in GitHub Actions. The workflows will store their tfstate remotely in the storage account. Both workflows have an optional destroy option.

If you wish to remove the bootstrapped resources then you can run terraform destroy in your shell if you still have your local terraform.tfstate. Alternatively you can delete the resource group manually, and then clean up the repo by removing any of the files, workflows, and GitHub Actions variables.
