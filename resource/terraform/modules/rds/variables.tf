variable "vpc_id" {
  type = string
  description = "VPC id"
}

variable "db_name" {
  description = "The name of the database to be created."
  default = "ec2_database"
  type = string
}

variable "db_instance_class" {
  description = "The instance class for the RDS instance."
  default = "db.t3.micro"
  type = string
}

variable "engine" {
  description = "The database engine to use for the RDS instance (e.g., mysql, postgresql)."
  default = "mysql"
  type = string
}

variable "engine_version" {
  description = "The version of the database engine to use (e.g., 8.0 for MySQL)."
  default = "8.0"
  type = string
}

variable "secrets_manager_secret_id" {
  description = "The ID of the Secrets Manager secret containing the database credentials."
  type = string
}

variable "vpc_security_group_id" {
  description = "The ID of the VPC security group to allow access to the RDS instance."
  type = string
}

variable "private_subnet_ids" {
  description = "A list of private subnet IDs within the VPC for the RDS instance."
  type = list(string)
}

variable "is_set_database_url" {
  type = bool
  default = true
}

variable "instance_id" {
  type = string
  description = "EC2 instance id to set database url to environment"
}

variable "database_variable_string" {
  type = string
  default = "DATABASE_URL"
  description = "The variable to connect RDS in the EC2 to run app"
}
