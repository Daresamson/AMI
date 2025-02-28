provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "packer_builder" {
  ami           = "ami-04b4f1a9cf54c11d0"  // Base AMI
  instance_type = "t2.micro"

  tags = {
    Name = "Packer Builder"
  }

  iam_instance_profile = aws_iam_instance_profile.packer_profile.name
}

resource "aws_iam_role" "packer" {
  name = "packer-build-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect    = "Allow"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "packer_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  role       = aws_iam_role.packer.name
}

resource "aws_iam_instance_profile" "packer_profile" {
  name = "packer-profile"
  role = aws_iam_role.packer.name
}