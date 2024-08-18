terraform {
  required_providers {
    vultr = {
      source  = "vultr/vultr"
      version = "2.21.0"
    }
    github = {
      source  = "integrations/github"
      version = "6.2.3"
    }
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "1.22.0"
    }
  }
}

provider "vultr" {}

provider "github" {}

provider "postgresql" {
  host     = vultr_database.this.host
  port     = vultr_database.this.port
  username = vultr_database.this.user
  password = vultr_database.this.password
  database = vultr_database.this.dbname
}