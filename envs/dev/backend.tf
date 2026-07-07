terraform {
  backend "s3" {
    bucket         = "terraform-state-nadia-devops"
    key            = "dev/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
