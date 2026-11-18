locals {
  organization = {
    name = "floci-lab"
  }

  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars  = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  account_name = local.account_vars.locals.account_name
  account_id   = local.account_vars.locals.account_id
  region       = local.region_vars.locals.region
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"

  contents = <<EOF
provider "aws" {
  region     = "${local.region}"
  access_key = "test"
  secret_key = "test"

  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  s3_use_path_style           = true

  endpoints {
    s3       = "http://localhost:4566"
    ssm      = "http://localhost:4566"
    dynamodb = "http://localhost:4566"
    sts      = "http://localhost:4566"
  }

  default_tags {
    tags = {
      Env       = "${local.account_name}"
      ManagedBy = "Terragrunt"
    }
  }
}
EOF
}

remote_state {
  backend = "s3"

  config = {
    bucket = "terraform-state"
    key    = "${path_relative_to_include()}/terraform.tfstate"
    region = "eu-north-1"

    endpoint         = "http://localhost:4566"
    dynamodb_endpoint = "http://localhost:4566"
    dynamodb_table   = "dlock"

    access_key = "test"
    secret_key = "test"

    skip_credentials_validation = true
    skip_region_validation      = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true
    use_path_style              = true
    encrypt                     = false
  }
}

inputs = merge(
  local.organization,
  local.account_vars.locals,
  local.region_vars.locals,
)