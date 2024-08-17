output "bastion_ip" {
  description = "Public IPv4 address of the bastion host"
  value       = vultr_instance.bastion.main_ip
}

output "database_name" {
  description = "Name of the database"
  value       = vultr_database.this.dbname
}

output "database_host" {
  description = "Name of the database"
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