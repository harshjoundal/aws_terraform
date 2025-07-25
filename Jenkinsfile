pipeline {
   agent any // Uses the Jenkins agent directly

  parameters {
    booleanParam(
      name: 'APPLY',
      defaultValue: true,
      description: 'Check to apply Terraform changes, uncheck to destroy infrastructure'
    )
    booleanParam(
      name: 'DESTROY',
      defaultValue: false,
      description: 'terrafoprm destroy'
    )
  }

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

    stage('Terraform Apply or Destroy') {
      steps {
        script {
          if (params.APPLY) {
            echo 'Applying Terraform configuration...'
            sh 'terraform apply -auto-approve'
          } else {
            echo 'Destroying Terraform infrastructure...'
            sh 'terraform destroy -auto-approve'
          }
        }
      }
    }
  }

  post {
    always {
      script {
        if (params.APPLY) {
          echo 'Terraform apply operation completed!'
        } else {
          echo 'Terraform destroy operation completed!'
        }
      }
    }
    success {
      script {
        if (params.APPLY) {
          echo 'Terraform deployment completed successfully!'
        } else {
          echo 'Infrastructure destroyed successfully!'
        }
      }
    }
    failure {
      echo 'Pipeline failed! Check logs for details.'
    }
  }
}
