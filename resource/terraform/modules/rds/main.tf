locals {
  ports = {
    mysql = 3306
  }
  base_tags = {
    Terraform   = true
    Environment = "dev"
    Author      = "tsukpa"
  }
}

###############################
# Security group
###############################

module "sg_rds" {
  source     = "cloudposse/security-group/aws"
  version    = "2.2.0"
  attributes = ["rds-sg"]

  rule_matrix = [
    # Allow any of these security groups or the specified prefixes to access MySQL
    {
      source_security_group_ids = [var.vpc_security_group_id]
      rules = [
        {
          key         = "mysql"
          type        = "ingress"
          from_port   = 3306
          to_port     = 3306
          protocol    = "tcp"
          description = "Allow MySQL access from trusted security groups"
        }
      ]
    }
  ]

  vpc_id = var.vpc_id
  tags   = local.base_tags
}

###############################
# Secrets Manager
###############################

# Reference the Secrets Manager secret for credentials
resource "aws_secretsmanager_secret" "db_credentials" {
  name = var.secrets_manager_secret_id
  tags = merge(local.base_tags, {
    Name = "RDS Credentials"
  })
}

# Decode the JSON-encoded credentials from the secret
locals {
  creds = jsondecode(data.aws_secretsmanager_secret.db_credentials.secret_string)
}

# Manage version of secrets manager
resource "aws_secretsmanager_secret_version" "db_credentials_version" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = local.creds.password
  depends_on = [ aws_secretsmanager_secret.db_credentials ]
}

###############################
# Database instance
###############################

# Create subnet group
resource "aws_db_subnet_group" "ec2_rds_subnet_group" {
  name       = "ec2_rds_subnet_group"
  subnet_ids = var.private_subnet_ids

  tags = merge(local.base_tags, {
    Name = "RDS Subnet Group"
  })
}

# Create the RDS instance
resource "aws_db_instance" "rds_instance" {
  allocated_storage = 20
  storage_encrypted = true
  storage_type      = "gp3"

  engine         = var.engine
  engine_version = var.engine_version

  db_name        = var.db_name
  instance_class = var.db_instance_class

  # Credentials
  username = local.creds.username
  password = local.creds.password

  # Connecting
  db_subnet_group_name   = aws_db_subnet_group.ec2_rds_subnet_group.name
  vpc_security_group_ids = [module.sg_rds.id]

  tags = merge(local.base_tags, {
    Name = "EC2 RDS instance"
  })

  depends_on = [ aws_secretsmanager_secret_version.db_credentials_version ]
}

###############################
# SSM Parameter Store
###############################

resource "aws_ssm_parameter" "database_url" {
  name  = var.database_variable_string
  type  = "String"
  value = aws_rds_instance.rds_instance.endpoint
}

resource "null_resource" "set_database_url" {
  count = var.is_set_database_url == true ? 1 : 0
  provisioner "local-exec" {
    on_failure = continue
    command = templatefile(("${path.cwd}/scripts/set-parameter.tmpl"), {
      instance_id = var.instance_id
      parameter_name = aws_ssm_parameter.database_url.name
    })
  }
}
