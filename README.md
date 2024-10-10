# Terraform  Bootstrap

Example bootstrap for both Azure DevOps and GitHub Actions using federated workload identities.

## Create a new repo

I find I use one of two workflows. I either create a new repo in GitHub, clone it down and then start working, or I create one locally and then push it up. I'll cover the former here, and then add the second as an option at the bottom of this readme.

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
```

Note that you can also use organization names as the value for github_owner_name.

Additional variables may be found in variables.tf.

## Run terraform

1. Initialise

    ```shell
    terraform init
    ```

1. Apply

    ```shell
    terraform apply
    ```
