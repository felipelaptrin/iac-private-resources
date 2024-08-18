output "runner_ip" {
  description = "Public IPv4 address of the self-hosted instance"
  value       = vultr_instance.runner.main_ip
}

output "database_name" {
  description = "Name of the database"
  value       = vultr_database.this.dbname
}

output "database_host" {
  description = "Host of the database"
  value       = vultr_database.this.host
}

output "database_port" {
  description = "Port of the database"
  value       = vultr_database.this.port
}

output "database_user" {
  description = "User of the database"
  value       = vultr_database.this.user
}

output "database_password" {
  description = "Password of the database"
  value       = vultr_database.this.password
  sensitive   = true
}