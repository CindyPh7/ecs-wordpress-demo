##########################################################################################
# ECS #
##########################################################################################

data "aws_iam_policy_document" "ecs_task_role_policy" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "kms:Decrypt",
      "ssm:GetParameters",
      "secretsmanager:GetSecretValue",
      "iam:PassRole"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role" "ecs_execution_role" {
  name        = var.ecs_execution_role_name
  description = "ECS task execution role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "ecs_execution_role_policy" {
  name   = var.ecs_execution_role_name
  role   = aws_iam_role.ecs_execution_role.id
  policy = data.aws_iam_policy_document.ecs_task_role_policy.json
}

# Create ECS cluster
resource "aws_ecs_cluster" "wordpress_cluster" {
  name = "${var.project}-cluster"
}

# Define the ECS Task Definition
resource "aws_ecs_task_definition" "wordpress" {
  family                   = "wordpress"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  container_definitions = jsonencode([
    {
      name   = "wordpress"
      image  = "${aws_ecr_repository.app_registry.repository_url}:latest"
      cpu    = 256
      memory = 512
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ],
      environment = [
        {
          name  = "WORDPRESS_DB_HOST"
          value = aws_db_instance.wordpress.endpoint
        },
        {
          name  = "WORDPRESS_DB_USER"
          value = aws_db_instance.wordpress.username
        },
        {
          name  = "WORDPRESS_DB_PASSWORD"
          value = aws_db_instance.wordpress.password
        },
        {
          name  = "WORDPRESS_DB_NAME"
          value = aws_db_instance.wordpress.db_name
        },
        {
          name  = "WORDPRESS_AUTH_KEY"
          value = random_password.salt_auth_key.result
        },
        {
          name  = "WORDPRESS_SECURE_AUTH_KEY"
          value = random_password.salt_secure_auth_key.result
        },
        {
          name  = "WORDPRESS_LOGGED_IN_KEY"
          value = random_password.salt_logged_in_key.result
        },
        {
          name  = "WORDPRESS_NONCE_KEY"
          value = random_password.salt_nonce_key.result
        },
        {
          name  = "WORDPRESS_AUTH_SALT"
          value = random_password.salt_auth_salt.result
        },
        {
          name  = "WORDPRESS_SECURE_AUTH_SALT"
          value = random_password.salt_secure_auth_salt.result
        },
        {
          name  = "WORDPRESS_LOGGED_IN_SALT"
          value = random_password.salt_logged_in_salt.result
        },
        {
          name  = "WORDPRESS_NONCE_SALT"
          value = random_password.salt_nonce_salt.result
        },
      ],
    },
  ])

}

# Create ECS service
resource "aws_ecs_service" "wordpress_service" {
  name            = "${var.project}-service"
  cluster         = aws_ecs_cluster.wordpress_cluster.id
  task_definition = aws_ecs_task_definition.wordpress.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets = [
      module.vpc.public_subnets[0],
    ]
    security_groups = [
      aws_security_group.wordpress_sg.id
    ]
    assign_public_ip = true
  }

  # load_balancer {
  #   target_group_arn = aws_alb_target_group.wordpress_tg.arn
  #   container_name   = "wordpress"
  #   container_port   = 80
  # }

}
