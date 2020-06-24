# tk-base

This Terraform module sets up some prerequisites for running tests using [Test Kitchen](https://docs.chef.io/workstation/kitchen/) and [inSpec](https://www.inspec.io/) as configured in [Cloud Foundation Toolkit](https://github.com/terraform-google-modules) Terraform modules.

What is created by this module:

* A folder to contain projects and resources created during testing. This folder is created within a parent folder, which must be passed in as a variable.

* A host project in the folder with required services enabled.

* A service account in the host project.

* Permissions for the service account to create new projects in the folder, and to associate them with the billing account.

# Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| billing_id | ID of billing account to associate with projects. | string | | yes |
| folder\_admin\_roles | Roles assigned to folder admins, if defined. | list(string) | `[]` | no |
| folder\_admins | Optional member names of folder admins. | list(string) | `[]` | no |
| parent\_folder\_id | ID of parent folder in which dedicated test folder will be created. | string | | yes |
| organization\_id | ID of organization. | string | | yes |
| name | Base name given to resources in module. | string | | yes |

# Outputs

| Name | Description |
|------|-------------|
| billing_id | ID of billing account. |
| folder_id | ID of created folder. |
| host_project_id | ID of host project containing service account. |
| organization_id | ID of organization. |
| service_account_email | Email address of service account. |

# Example Usage

Create a `tfvars` file:

```
billing_id        = "CFP509-JTZ984-NHJ63Q"
parent_folder_id  = "2505152174137"
organization_id   = "064020049231"
name              = "tk-base"
```

Then run:

```
terraform init
terraform plan -out tfapply -var-file vars.tfvars
terraform apply tfapply
```

# Testing with Test Kitchen

Follow the instructions at [terraform-google-module-template](https://github.com/terraform-google-modules/terraform-google-module-template) to create a module that follows the CFT conventions. The module will contain a Makefile which has targets for running tests using Test Kitchen and inSpec. These targets use `docker run`, so Docker must be installed.

You'll need to generate a key file for the service account. The host project ID and email address of the service account are outputs of this module. Use them in the following commands:

```
gcloud set project ${host_project_id}
gcloud iam service-accounts keys create credentials.json --iam-account ${service_account_email}
```

In the folder containing `credentials.json`, run the following to set some required environment variables, again using outputs of the Terraform module:

```
export TF_VAR_billing_account=${billing_account_id}
export TF_VAR_org_id=${organization_id}
export TF_VAR_folder_id=${folder_id}
export SERVICE_ACCOUNT_JSON=`cat credentials.json`
```

Prepare for tests by creating a new project:

```
make docker_test_prepare
```

Then run the integration tests. This creates fixtures defined in `./test/fixtures`, runs inSpec tests defined in `./test/integration`, and then removes the fixtures.

```
make docker_test_integration
```

Finally, clean up the project.

```
make docker_test_cleanup
```
