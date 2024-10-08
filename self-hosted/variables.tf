variable "repo_name" {
  description = "Github repository name including the owner (e.g. felipelaptrin/my-repo)"
  type        = string
}

variable "public_ssh_key" {
  description = "Public SSH key to attach to the authorized_keys of the self-hosted runner host"
  type        = string
}

variable "github_actions_version" {
  description = "Version that the self-hosted runner will use. You can check all version here: https://github.com/actions/runner/releases"
  type        = string
  default     = "v2.319.1"
}