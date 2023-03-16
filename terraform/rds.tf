##########################################################################################
# RDS Instance #
##########################################################################################

# Create RDS Subnet Group
resource "aws_db_subnet_group" "wordpress_rds_subnet_group" {
  name       = "${var.project}-rds-subnet-grp"
  subnet_ids = module.vpc.private_subnets

  tags = {
    Name = "${var.project}-rds-subnet-grp"
  }
}

# Create RDS database
resource "aws_db_instance" "wordpress" {
  allocated_storage          = 20
  engine                     = "mysql"
  engine_version             = "5.7"
  instance_class             = var.rds_instance_class
  db_subnet_group_name       = aws_db_subnet_group.wordpress_rds_subnet_group.id
  db_name                    = var.rds_db_name
  username                   = var.rds_username
  password                   = local.db_password
  parameter_group_name       = "default.mysql5.7"
  storage_encrypted          = true
  auto_minor_version_upgrade = true
  skip_final_snapshot        = true

  tags = {
    Name = "${var.project}-rds-db-instance"
  }
}
