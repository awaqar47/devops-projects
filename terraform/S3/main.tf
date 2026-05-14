terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.44.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

# Create S3 Bucket
resource "aws_s3_bucket" "mys3bucket" {
  bucket = "s3bucket-wqr4743"
}

# Upload File to S3
resource "aws_s3_object" "bucket_data" {
  bucket = aws_s3_bucket.mys3bucket.id
  key    = "Data.txt"
  source = "./demodata.txt"
}

# Create IAM Policy
resource "aws_iam_policy" "AmazonS3FilesFullAccess_Policy" {
  name = "AmazonS3FilesFullAccess_Policy"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "S3FilesPermissions",
            "Effect": "Allow",
            "Action": "s3files:*",
            "Resource": "*"
        },
        {
            "Sid": "EC2NetworkingPermissions",
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeSubnets",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DescribeNetworkInterfaceAttribute",
                "ec2:CreateNetworkInterface",
                "ec2:DeleteNetworkInterface",
                "ec2:ModifyNetworkInterfaceAttribute",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeVpcs",
                "ec2:DescribeAvailabilityZones"
            ],
            "Resource": "*"
        },
        {
            "Sid": "S3BucketPermissions",
            "Effect": "Allow",
            "Action": [
                "s3:GetBucketNotification",
                "s3:PutBucketNotification"
            ],
            "Resource": "arn:aws:s3:::*"
        }
    ]
}
POLICY
}

# Attach Policy to Existing IAM User
resource "aws_iam_user_policy_attachment" "attach_policy" {
  user       = "awaqar"
  policy_arn = aws_iam_policy.AmazonS3FilesFullAccess_Policy.arn
}
