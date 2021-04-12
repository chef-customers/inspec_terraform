# inspec_terraform

Sample repository with contents showing usage of Chef Inspec with HashiCorp Terraform.

- [inspec_terraform](#inspec_terraform)
  - [Requirements](#requirements)
  - [inspec-terraform](#inspec-terraform)
    - [amz_server_inspec Terraform module](#amz_server_inspec-terraform-module)
    - [my_profile Chef Inspec Profile](#my_profile-chef-inspec-profile)
  - [my-aws-profile](#my-aws-profile)
    - [Rakefile Tasks](#rakefile-tasks)
    - [my-aws-profile Chef Inspec profile](#my-aws-profile-chef-inspec-profile)

## Requirements

Usage of included sample repositories assumes that the following tools are installed on the local system for development and testing purposes:

- [Chef Workstation](https://downloads.chef.io/tools/workstation)
- [HashiCorp Terraform](https://www.terraform.io/)
  - Testing performed with Terraform v14
- [AWS CLI](https://aws.amazon.com/cli/)
  - Assumes usage of profile-based authentiction as provided by config/credentials file.

## inspec-terraform

Sample Terraform repository which uses Chef Inspec for inline validation of the plan as it is applied.  Includes local Inspec profile `my_profile` included in folder path.

Usage:
```shell
cd inspec-terraform
terraform init
terraform plan
terraform apply --auto-approve || terraform destroy --auto-approve
```

### amz_server_inspec Terraform module

Terraform configuration file located at `inspec-terraform/main.tf` references included `amz_server_inspec` module, located at `modules/amz_server_inspec`.  Sample/example data should be populated with environment-specific information as required for testing.

Chef Inspec profile execution of `my_profile` is configured as `local_exec` provisioner during plan apply process.

### my_profile Chef Inspec Profile

Sample Chef Inspec profile located at `./my_profile`.  Controls included are run with target of provisioned EC2 instance, validating the presence of installed packages which are provisioned during Terraform apply process.

Additionally includes test for the presence of package `some_package_not_installed` which will show as a failure to emulate what happens when a test process fails.

## my-aws-profile

Sample Inspec repository which uses Terraform to provision test resources for development and validation of profile.

Includes `Rakefile` to use for interactions with Terraform for provisioning:

```plain
$ chef exec rake -T
rake default            # Execute Terraform Apply, Inspex Exec and Terraform Destroy
rake inspec_exec        # Execute Inspec Exec with embedded test suite
rake terraform_apply    # Execute Terraform Apply
rake terraform_cleanup  # Execute Terraform Destroy
```

### Rakefile Tasks

- default
  - Executes tasks `terraform_apply`, `inspec_exec` and then `terraform_cleanup` in order.
- terraform_apply
  - Uses Terraform configuration located at `test/integration/build/aws.tf` to provision AWS VPC.
  - Environment-specific configuration data should be updated in `config` hash, within `Rakefile`.
  - Runs `terraform init` from build directory
  - Generates tfvars file and Inputs file, saving them to `build` directory, using data which is populated in `config` hash of the `Rakefile`.
  - Runs `terraform plan` using the created tfvars file, saving the plan output file to the `build` directory.
  - Runs `terraform apply` of the generated plan file from the previous step.
  - Updates the Inspec inputs file with output of `terraform apply`
- inspec_exec
  - Executes `inspec exec` using Input data from the inputs file created during the `terraform_apply` task.
  - `CONTROLS_DIR` setting located in `Rakefile` determines which Inspec profile is used for testing during `inspec exec` process.  Default configuration uses path located at `test/integration/verify`.
- terraform_cleanup
  - Runs `terraform destroy` using the tfvars generated during the `terraform_apply` task.

### my-aws-profile Chef Inspec profile

Chef Inspec profile which uses [Input data](https://docs.chef.io/inspec/inputs/) to check for the existence of an AWS VPC.

```shell
cd my-aws-profile
inspec exec . -t aws:// --input aws_vpc_id=VPCIDXXXXXXXX
```
