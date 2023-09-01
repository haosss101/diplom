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
                withAWS(credentials: 'AWS_creds', region: 'us-east-1'){ //AWS Plugin
                   sh 'sudo terraform init
                }
                    
                #sh 'sudo terraform init -backend-config="access_key=AKIARNGVWZTHDK5ZJGN2" -backend-config="secret_key=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"'                   
                               
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
