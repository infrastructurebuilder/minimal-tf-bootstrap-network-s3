data "aws_caller_identity" "current" {}

# Admin policy: full read-write access, scoped to state/* keys only
resource "aws_iam_policy" "terraform_state_admin" {
  name        = "${var.state_bucket_name}-admin"
  description = "Full read-write access to the Terraform state S3 bucket, scoped to state/* keys"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "BucketMetadata"
        Effect = "Allow"
        Action = [
          "s3:GetBucketLocation",
          "s3:GetBucketVersioning",
        ]
        Resource = aws_s3_bucket.terraform_state.arn
      },
      {
        Sid    = "ListState"
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:ListBucketVersions",
        ]
        Resource = aws_s3_bucket.terraform_state.arn
        Condition = {
          StringLike = {
            "s3:prefix" = ["state/*"]
          }
        }
      },
      {
        Sid    = "ReadWriteState"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:DeleteObjectVersion",
        ]
        Resource = "${aws_s3_bucket.terraform_state.arn}/state/*"
      },
    ]
  })

  tags = {
    Name = "${var.state_bucket_name}-admin"
  }
}

# Read-only policy: read access scoped to state/* keys only
resource "aws_iam_policy" "terraform_state_readonly" {
  name        = "${var.state_bucket_name}-readonly"
  description = "Read-only access to the Terraform state S3 bucket, scoped to state/* keys"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "BucketMetadata"
        Effect = "Allow"
        Action = [
          "s3:GetBucketLocation",
          "s3:GetBucketVersioning",
        ]
        Resource = aws_s3_bucket.terraform_state.arn
      },
      {
        Sid    = "ListState"
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:ListBucketVersions",
        ]
        Resource = aws_s3_bucket.terraform_state.arn
        Condition = {
          StringLike = {
            "s3:prefix" = ["state/*"]
          }
        }
      },
      {
        Sid    = "ReadState"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
        ]
        Resource = "${aws_s3_bucket.terraform_state.arn}/state/*"
      },
    ]
  })

  tags = {
    Name = "${var.state_bucket_name}-readonly"
  }
}

# Restricted-write policy: read all state/* keys, write only to state/* keys not under state/protected/
resource "aws_iam_policy" "terraform_state_restricted_write" {
  name        = "${var.state_bucket_name}-restricted-write"
  description = "Read-write access to state/* keys; write blocked for keys beginning with 'state/protected/'"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "BucketMetadata"
        Effect = "Allow"
        Action = [
          "s3:GetBucketLocation",
          "s3:GetBucketVersioning",
        ]
        Resource = aws_s3_bucket.terraform_state.arn
      },
      {
        Sid    = "ListState"
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:ListBucketVersions",
        ]
        Resource = aws_s3_bucket.terraform_state.arn
        Condition = {
          StringLike = {
            "s3:prefix" = ["state/*"]
          }
        }
      },
      {
        Sid    = "ReadWriteState"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:DeleteObjectVersion",
        ]
        Resource = "${aws_s3_bucket.terraform_state.arn}/state/*"
      },
      {
        Sid    = "DenyWriteProtected"
        Effect = "Deny"
        Action = [
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:DeleteObjectVersion",
        ]
        Resource = "${aws_s3_bucket.terraform_state.arn}/state/protected/*"
      },
    ]
  })

  tags = {
    Name = "${var.state_bucket_name}-restricted-write"
  }
}

# ==============================================================================
# IAM ROLES FOR TERRAFORM STATE S3 BUCKET
# ==============================================================================

locals {
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowAssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })
}

resource "aws_iam_role" "terraform_state_admin" {
  name               = "${var.state_bucket_name}-admin"
  description        = "Role with full read-write access to the Terraform state S3 bucket"
  assume_role_policy = local.assume_role_policy

  tags = {
    Name = "${var.state_bucket_name}-admin"
  }
}

resource "aws_iam_role_policy_attachment" "terraform_state_admin" {
  role       = aws_iam_role.terraform_state_admin.name
  policy_arn = aws_iam_policy.terraform_state_admin.arn
}

resource "aws_iam_role" "terraform_state_readonly" {
  name               = "${var.state_bucket_name}-readonly"
  description        = "Role with read-only access to the Terraform state S3 bucket"
  assume_role_policy = local.assume_role_policy

  tags = {
    Name = "${var.state_bucket_name}-readonly"
  }
}

resource "aws_iam_role_policy_attachment" "terraform_state_readonly" {
  role       = aws_iam_role.terraform_state_readonly.name
  policy_arn = aws_iam_policy.terraform_state_readonly.arn
}

resource "aws_iam_role" "terraform_state_restricted_write" {
  name               = "${var.state_bucket_name}-restr-w-role"
  description        = "Role with read access to all state/* keys and write access only to non-protected keys"
  assume_role_policy = local.assume_role_policy

  tags = {
    Name = "${var.state_bucket_name}-restr-w-role"
  }
}

resource "aws_iam_role_policy_attachment" "terraform_state_restricted_write" {
  role       = aws_iam_role.terraform_state_restricted_write.name
  policy_arn = aws_iam_policy.terraform_state_restricted_write.arn
}
