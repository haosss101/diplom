pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/haosss101/diplom.git']])
            }
        }

        stage('Terraform init with credentials for S3') {
            steps {
                withCredentials([[
                $class: 'AmazonWebServicesCredentialsBinding',
                credentialsId: '101',
                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                    
                sh 'sudo terraform init'
            }
                   
        }
                 
    }
        
        stage('Disable KMS') {
            steps {
                sh 'sudo cp ~/main.tf ~/workspace/diplom/.terraform/modules/eks'
            }
        }
    
        stage('Terraform apply') {
            steps {
                sh 'terraform apply --auto-approve'

            }

        }

    }

}
