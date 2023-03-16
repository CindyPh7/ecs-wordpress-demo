<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | > 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.58.0 |
| <a name="requirement_http"></a> [http](#requirement\_http) | 3.2.1 |
| <a name="requirement_local"></a> [local](#requirement\_local) | 2.4.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.4.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.58.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.4.3 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_network"></a> [network](#module\_network) | ./modules/network | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_db_instance.wordpress](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/db_instance) | resource |
| [aws_db_subnet_group.wordpress_rds_subnet_group](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/db_subnet_group) | resource |
| [aws_ecr_repository.app_registry](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/ecr_repository) | resource |
| [aws_ecr_repository_policy.app_registry_policy](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/ecr_repository_policy) | resource |
| [aws_ecs_cluster.wordpress_cluster](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/ecs_cluster) | resource |
| [aws_ecs_service.wordpress_service](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.wordpress](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/ecs_task_definition) | resource |
| [aws_iam_role.ecs_execution_role](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.ecs_execution_role_policy](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/iam_role_policy) | resource |
| [aws_secretsmanager_secret.db_password](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.wordpress_salt](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.db_password](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.wordpress_salt](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/secretsmanager_secret_version) | resource |
| [aws_security_group.rds_sg](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/security_group) | resource |
| [aws_security_group.wordpress_sg](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/security_group) | resource |
| [random_password.db_password](https://registry.terraform.io/providers/hashicorp/random/3.4.3/docs/resources/password) | resource |
| [random_password.salt_auth_key](https://registry.terraform.io/providers/hashicorp/random/3.4.3/docs/resources/password) | resource |
| [random_password.salt_auth_salt](https://registry.terraform.io/providers/hashicorp/random/3.4.3/docs/resources/password) | resource |
| [random_password.salt_logged_in_key](https://registry.terraform.io/providers/hashicorp/random/3.4.3/docs/resources/password) | resource |
| [random_password.salt_logged_in_salt](https://registry.terraform.io/providers/hashicorp/random/3.4.3/docs/resources/password) | resource |
| [random_password.salt_nonce_key](https://registry.terraform.io/providers/hashicorp/random/3.4.3/docs/resources/password) | resource |
| [random_password.salt_nonce_salt](https://registry.terraform.io/providers/hashicorp/random/3.4.3/docs/resources/password) | resource |
| [random_password.salt_secure_auth_key](https://registry.terraform.io/providers/hashicorp/random/3.4.3/docs/resources/password) | resource |
| [random_password.salt_secure_auth_salt](https://registry.terraform.io/providers/hashicorp/random/3.4.3/docs/resources/password) | resource |
| [aws_iam_policy_document.app_registry_policy](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ecs_task_role_policy](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | Region where to deploy the | `string` | `"us-west-1"` | no |
| <a name="input_ecr_repository_name"></a> [ecr\_repository\_name](#input\_ecr\_repository\_name) | ECR repository name | `string` | `"devops-app-registry/wordpress"` | no |
| <a name="input_ecs_execution_role_name"></a> [ecs\_execution\_role\_name](#input\_ecs\_execution\_role\_name) | ECS execution role name | `string` | `"ecs-task-execution-role"` | no |
| <a name="input_private_subnets_cidr"></a> [private\_subnets\_cidr](#input\_private\_subnets\_cidr) | Private subnet CIDR block | `list(string)` | <pre>[<br>  "10.0.2.0/24",<br>  "10.0.3.0/24"<br>]</pre> | no |
| <a name="input_project"></a> [project](#input\_project) | Project name | `string` | `"wordpress-demo"` | no |
| <a name="input_public_subnets_cidr"></a> [public\_subnets\_cidr](#input\_public\_subnets\_cidr) | Public subnet CIDR block | `list(string)` | <pre>[<br>  "10.0.1.0/24"<br>]</pre> | no |
| <a name="input_rds_db_name"></a> [rds\_db\_name](#input\_rds\_db\_name) | RDS database name | `string` | `"wordpress"` | no |
| <a name="input_rds_instance_class"></a> [rds\_instance\_class](#input\_rds\_instance\_class) | RDS instance size | `string` | `"db.t3.micro"` | no |
| <a name="input_rds_username"></a> [rds\_username](#input\_rds\_username) | RDS database username | `string` | `"wordpress_user"` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | VPC CIDR block | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ecr_repository_url"></a> [ecr\_repository\_url](#output\_ecr\_repository\_url) | Output ECR repository URL |
<!-- END_TF_DOCS -->
