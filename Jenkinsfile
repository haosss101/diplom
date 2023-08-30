pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/haosss101/diplom.git']])
            }
        }

        stage('Terraform init') {
            steps {
                sh 'sudo terraform init -backend-config="access_key=AKIARNGVWZTHDK5ZJGN2" -backend-config="secret_key=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"'
            }
        }
        
        stage('Terraform apply') {
            steps {
                sh 'terraform apply --auto-approve'

            }

        }

    }

}
