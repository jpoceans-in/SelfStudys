terraform {
  backend "s3" {
    bucket         = "jpoterraform-terraform-state"
    key            = "Dev/terraform.tfstate"
    region         = "ap-south-1"  # Specify your AWS region
    dynamodb_table = "jpoTerraform-table-name"
    encrypt = true
  }
}