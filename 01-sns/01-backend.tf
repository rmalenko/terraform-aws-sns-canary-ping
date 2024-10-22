# // The referenced S3 bucket must have been previously created.

# terraform {
#   backend "s3" {
#     bucket         = "terraform-state-chessclub-us-east-1"
#     dynamodb_table = "terraform-state-chessclub-us-east-1"
#     encrypt        = true
#     key            = "r53/r53-terraform.tfstate"
#     profile        = "v2prod_main"
#     region         = "us-east-1"
#   }
# }
