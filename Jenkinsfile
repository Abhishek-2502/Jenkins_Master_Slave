pipeline {
    agent { label 'private_repo' }

    environment {
        IMAGE_NAME = 'flask-app'
        CONTAINER_NAME = 'flask_app_container'
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code from private repo...'
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                sh "docker build -t $IMAGE_NAME ."
            }
        }

        stage('Run Flask App') {
            steps {
                echo 'Running Flask app container...'
                sh "docker run -d -p 5000:5000 --name $CONTAINER_NAME $IMAGE_NAME"
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check logs.'
            sh "docker logs $CONTAINER_NAME || true"
        }
        always {
            echo 'Cleaning up...'
            sh "docker rm -f $CONTAINER_NAME || true"
        }
    }
}
