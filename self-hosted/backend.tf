terraform {
  backend "s3" {
    bucket                      = "terraform-states-demosfelipetrindade"
    key                         = "iac-private-resources-self-hosted-runner.tfstate"
    endpoint                    = "ewr1.vultrobjects.com"
    region                      = "us-east-1"
    skip_credentials_validation = true
  }
}