pipeline {
    agent { label 'master_slave' }

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code from private repo...'
                checkout scm
            }
        }

        stage('Deploy with Docker Compose') {
            steps {
                echo 'Building and deploying with docker-compose...'
                sh 'docker-compose up -d --build'
            }
        }
    }

    post {
        success {
            echo 'Deployment completed successfully!'
        }
        failure {
            echo 'Deployment failed! Check logs.'
        }
    }
}
