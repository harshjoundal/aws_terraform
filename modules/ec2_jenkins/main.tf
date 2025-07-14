data "aws_iam_policy_document" "ec2_trust" {
    statement {
      effect = "Allow"
      actions = ["sts:AssumeRole"] 
      principals {
        type        = "Service"
        identifiers = ["ec2.amazonaws.com"]
      }
    }
}

resource "aws_iam_role" "jenkins_role" {
    name = "jenkins_role"
    assume_role_policy = data.aws_iam_policy_document.ec2_trust.json
}

resource "aws_iam_policy" "jenkins_policy" {
    name = "jenkins_policy"
    description = "Policy for Jenkins EC2 instance"
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Action = [
                    "ec2:*",
                    "s3:*",
                    "eks:*",
                    "iam:*",
                    "dynamodb:*"
                ],
                Resource = "*"
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "attach" {
    role = aws_iam_role.jenkins_role.name
    policy_arn = aws_iam_policy.jenkins_policy.arn
}

resource "aws_security_group" "jenkins_sg" {
    name = "jenkins_sg"
    description = "Security group for Jenkins EC2 instance"
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "jenkins" {
    ami = "ami-020cba7c55df1f615"
    instance_type = "t3.medium"
    key_name = "joundalharsh"
    security_groups = [aws_security_group.jenkins_sg.name]
    iam_instance_profile = aws_iam_instance_profile.jenkins_profile.name

    user_data = <<EOF
        #!/bin/bash
        # Update package index
        sudo apt update -y

        # Install dependencies
        sudo apt install -y fontconfig openjdk-21-jre git wget

        # Add Jenkins repo key
        sudo mkdir -p /etc/apt/keyrings
        sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

        # Add Jenkins repository
        echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

        # Update again to pick up Jenkins repo
        sudo apt update -y

        # Install Jenkins
        sudo apt install -y jenkins

        # Enable and start Jenkins service
        sudo systemctl enable jenkins
        sudo systemctl start jenkins
    EOF
}

resource "aws_iam_instance_profile" "jenkins_profile" {
    name = "jenkins_instance_profile"
    role = aws_iam_role.jenkins_role.name
}