pipeline {
    agent { label 'private_repo' }

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code from private repo...'
                checkout scm // Works if job is configured with repo + credentials
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                script {
                    docker.build('flask-app')
                }
            }
        }

        stage('Run Flask App') {
            steps {
                echo 'Running Flask app container...'
                sh 'docker run -d -p 5000:5000 flask-app'
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check logs.'
        }
    }
}
