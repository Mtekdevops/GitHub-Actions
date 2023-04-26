variable "GitHubOrg" {}
variable "RepositoryName" {}
variable "OIDCProviderArn" {
  default = ""
}

resource "aws_iam_role" "OIDCRole" {
  name = "GitHubOIDCRole"
  assume_role_policy = jsonencode({
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRoleWithWebIdentity"
        Principal = {
          Federated = "${coalesce(aws_iam_openid_connect_provider.GithubOidc[0].arn, var.OIDCProviderArn)}"
        }
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:${var.GitHubOrg}/${var.RepositoryName}:*"
          }
        }
      }
    ]
  })
}

#to allow the GitHub Actions runner to spin up the EKS cluster
resource "aws_iam_role_policy_attachment" "AdminAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = aws_iam_role.OIDCRole.name
}

resource "aws_iam_openid_connect_provider" "GithubOidc" {
  count   = var.OIDCProviderArn == "" ? 1 : 0
  url     = "https://token.actions.githubusercontent.com"
  client_id_list = [
    "sts.amazonaws.com"
  ]
  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1"
  ]
}

output "OIDCRole" {
  value = aws_iam_role.OIDCRole.arn
}
