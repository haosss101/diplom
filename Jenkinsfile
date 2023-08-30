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
                sh 'sudo terraform init'
            }
        }

        stage('Terraform apply') {
            steps {
                sh 'terraform apply --auto-approve'

            }

        }

    }

}
