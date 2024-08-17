data "vultr_os" "ubuntu" {
  filter {
    name   = "name"
    values = ["Ubuntu 22.04 LTS x64"]
  }
}

data "github_actions_registration_token" "this" {
  repository = var.repo_name
}