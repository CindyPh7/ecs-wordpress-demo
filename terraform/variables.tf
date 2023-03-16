##########################################################################################
# GLOBAL #
##########################################################################################

variable "project" {
  description = "Project name"
  type        = string
  default     = "wordpress-demo"
}

variable "aws_region" {
  description = "Region where to deploy the"
  type        = string
  default     = "us-west-1"
}

##########################################################################################
# NETWORK CONFIGURATION VARIABLES #
##########################################################################################


##############################################
# VPC
##############################################
variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

##############################################
# SUBNETS VARIABLES
##############################################

# PUBLIC SUBNET
variable "public_subnets_cidr" {
  description = "Public subnet CIDR block"
  type        = list(string)
  default = [
    "10.0.1.0/24"
  ]
}

# PRIVATE SUBNET
variable "private_subnets_cidr" {
  description = "Private subnet CIDR block"
  type        = list(string)
  default = [
    "10.0.2.0/24",
    "10.0.3.0/24"
  ]
}


##########################################################################################
# RDS CONFIGURATION VARIABLES #
##########################################################################################

# RDS instance variables
variable "rds_instance_class" {
  description = "RDS instance size"
  type        = string
  default     = "db.t3.micro"
}

variable "rds_db_name" {
  description = "RDS database name"
  type        = string
  default     = "wordpress"
}

variable "rds_username" {
  description = "RDS database username"
  type        = string
  default     = "wordpress_user"
}


##########################################################################################
# ECS CONFIGURATION VARIABLES #
##########################################################################################

# ECS Execution Role
variable "ecs_execution_role_name" {
  description = "ECS execution role name"
  type        = string
  default     = "ecs-task-execution-role"
}
