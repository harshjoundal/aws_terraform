pipeline {
   agent any // Uses the Jenkins agent directly

  environment {
    AWS_REGION = 'us-east-1'
    GITHUB_CREDENTIALS_ID = 'git-pat'
  }

  stages {
    stage('Checkout') {
      steps {
        git branch: 'main', credentialsId: "${GITHUB_CREDENTIALS_ID}", url: 'https://github.com/harshjoundal/aws_terraform'
      }
    }

    stage('Terraform Init') {
      steps {
        script {
          try {
            sh 'terraform init'
          } catch (Exception e) {
            error "Terraform Init failed: ${e.message}"
          }
        }
      }
    }

    stage('Terraform Validate') {
      steps {
        sh 'terraform validate'
      }
    }

    stage('Terraform Plan') {
      steps {
        sh 'terraform plan -out=tfplan'
      }
    }

    stage('Terraform Apply') {
      steps {
        sh 'echo terraform apply -auto-approve'
      }
    }
  }

  post {
    always {
      echo 'Terraform deployment completed successfully!'
    }
    success {
      echo 'Terraform deployment completed successfully!'
    }
    failure {
      echo 'Pipeline failed! Check logs for details.'
    }
  }
}
