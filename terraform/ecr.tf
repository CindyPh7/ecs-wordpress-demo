##########################################################################################
# ECR - CONTAINER REGISTRY #
##########################################################################################

# Create ECR repository
resource "aws_ecr_repository" "app_registry" {
  name         = "${var.project}-ecr/wordpress"
  force_delete = true
}

# Create ECR repository policys
data "aws_iam_policy_document" "app_registry_policy" {
  statement {
    sid    = "registry-policy"
    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeRepositories",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages",
      "ecr:DeleteRepository",
      "ecr:BatchDeleteImage",
      "ecr:SetRepositoryPolicy",
      "ecr:DeleteRepositoryPolicy",
      "ecr:GetAuthorizationToken"
    ]
  }
}

# Attach ECR repository policy
resource "aws_ecr_repository_policy" "app_registry_policy" {
  repository = aws_ecr_repository.app_registry.name
  policy     = data.aws_iam_policy_document.app_registry_policy.json
}
