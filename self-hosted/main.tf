locals {
  region                 = "mia" # Miami
  label                  = "self-hosted"
  github_actions_version = split("v", var.github_actions_version)[1]
  repo_name              = split("/", var.repo_name)[1]
}

############################
###### Networking
############################
resource "vultr_vpc" "this" {
  region         = local.region
  v4_subnet      = "10.0.0.0"
  v4_subnet_mask = 24
}

resource "vultr_firewall_group" "runner" {
  description = "Github self-runner Firewall"
}

resource "vultr_firewall_rule" "runner" {
  firewall_group_id = vultr_firewall_group.runner.id
  protocol          = "tcp"
  ip_type           = "v4"
  subnet            = "0.0.0.0"
  subnet_size       = 0
  port              = "22"
  notes             = "Allow all SSH from anywhere"
}

############################
###### Virual Machine
############################
resource "vultr_ssh_key" "runner" {
  name    = "runner"
  ssh_key = var.public_ssh_key
}

resource "vultr_instance" "runner" {
  region              = local.region
  vpc_ids             = [vultr_vpc.this.id]
  plan                = "vc2-1c-1gb"
  os_id               = data.vultr_os.ubuntu.id
  backups             = "disabled"
  label               = local.label
  firewall_group_id   = vultr_firewall_group.runner.id
  ssh_key_ids         = [vultr_ssh_key.runner.id]
  enable_ipv6         = true
  disable_public_ipv4 = false
  ddos_protection     = false
  activation_email    = false
  user_data           = <<EOF
#!/bin/bash
echo "ubuntu ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
cd /home/ubuntu && mkdir actions-runner && cd actions-runner
curl -o actions-runner-linux.tar.gz -L https://github.com/actions/runner/releases/download/${var.github_actions_version}/actions-runner-linux-x64-${local.github_actions_version}.tar.gz
tar xzf ./actions-runner-linux.tar.gz
sudo chown -R ubuntu /home/ubuntu/actions-runner
sudo -u ubuntu ./config.sh --name vultr --replace --url https://github.com/${var.repo_name} --token ${data.github_actions_registration_token.this.token}
sudo -u ubuntu ./run.sh
  EOF
}

############################
###### Database
############################
resource "vultr_database" "this" {
  region                  = local.region
  vpc_id                  = vultr_vpc.this.id
  plan                    = "vultr-dbaas-hobbyist-cc-1-25-1"
  database_engine         = "pg"
  database_engine_version = "15"
  label                   = local.label
  trusted_ips = [
    "${vultr_instance.runner.internal_ip}/32",
  ]
}

# resource "postgresql_database" "this" {
#   name = "demo"
# }
