//////////////////////////////
// Remote states for import //
//////////////////////////////

# data "terraform_remote_state" "mimir" {
#   backend = "s3"
#   config = {
#     profile                 = var.profile
#     shared_credentials_file = "~/.aws/credentials"
#     region                  = var.aws_region
#     bucket                  = "asg-wp-terraform-state-eu-central-1/"
#     key                     = "mimir/terraform.tfstate"
#   }
# }
