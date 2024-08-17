locals {
  region = "mia" # Miami
  label  = "ssh-proxy"
}

############################
###### Networking
############################
resource "vultr_vpc" "this" {
  region         = local.region
  v4_subnet      = "10.0.0.0"
  v4_subnet_mask = 24
}

resource "vultr_firewall_group" "bastion" {
  description = "Bastion Firewall"
}

resource "vultr_firewall_rule" "bastion" {
  firewall_group_id = vultr_firewall_group.bastion.id
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
# resource "vultr_reserved_ip" "bastion" {
#   label   = local.label
#   region  = local.region
#   ip_type = "v4"
# }

resource "vultr_ssh_key" "bastion" {
  name    = "bastion"
  ssh_key = var.public_ssh_key
}

resource "vultr_instance" "bastion" {
  region              = local.region
  vpc_ids             = [vultr_vpc.this.id]
  plan                = "vc2-1c-1gb"
  os_id               = data.vultr_os.ubuntu.id
  backups             = "disabled"
  label               = local.label
  firewall_group_id   = vultr_firewall_group.bastion.id
  ssh_key_ids         = [vultr_ssh_key.bastion.id]
  enable_ipv6         = true
  # reserved_ip_id      = vultr_reserved_ip.bastion.id
  disable_public_ipv4 = false
  ddos_protection     = false
  activation_email    = false
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
    "${vultr_instance.bastion.internal_ip}/32",
  ]
}

resource "postgresql_database" "this" {
  name = "demo"
}