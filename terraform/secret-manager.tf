##########################################################################################
# AWS SECRET MANAGER #
##########################################################################################

############################################
# DB INSTANCE SECRET
############################################

# Create a random password for the Wordpress DB instance
resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Create a secret for RDS instance in AWS Secret Manager
resource "aws_secretsmanager_secret" "db_password" {
  name                           = "${var.project}-db-password"
  force_overwrite_replica_secret = true
  recovery_window_in_days        = 0
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = local.db_password
}

############################################
# WORDPRESS SALT
############################################

# Generate the Wordpress Salt
resource "random_password" "salt_auth_key" {
  length  = 64
  special = true
}

resource "random_password" "salt_secure_auth_key" {
  length  = 64
  special = true
}

resource "random_password" "salt_logged_in_key" {
  length  = 64
  special = true
}

resource "random_password" "salt_nonce_key" {
  length  = 64
  special = true
}

resource "random_password" "salt_auth_salt" {
  length  = 64
  special = true
}

resource "random_password" "salt_secure_auth_salt" {
  length  = 64
  special = true
}

resource "random_password" "salt_logged_in_salt" {
  length  = 64
  special = true
}

resource "random_password" "salt_nonce_salt" {
  length  = 64
  special = true
}
