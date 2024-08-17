terraform {
  backend "s3" {
    bucket                      = "terraform-states-demosfelipetrindade"
    key                         = "iac-private-resources-ssh-proxy.tfstate"
    endpoint                    = "ewr1.vultrobjects.com"
    region                      = "us-east-1"
    skip_credentials_validation = true
  }
}