terraform {
  required_providers {
    vultr = {
      source  = "vultr/vultr"
      version = "2.21.0"
    }
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "1.22.0"
    }
  }
}

provider "vultr" {}

module "db_tunnel" {
  source  = "flaupretre/tunnel/ssh"
  version = "2.2.1"

  target_host = vultr_database.this.host
  target_port = vultr_database.this.port

  gateway_host = vultr_instance.bastion.main_ip
  gateway_user = "root"
}

provider "postgresql" {
  host     = module.db_tunnel.host
  port     = module.db_tunnel.port
  username = vultr_database.this.user
  password = vultr_database.this.password
  database = vultr_database.this.dbname
}