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

        stage('Clean Up Old Container') {
            steps {
                echo 'Stopping and removing any existing container...'
                sh """
                    if [ \$(docker ps -a -q -f name=$CONTAINER_NAME) ]; then
                        docker stop $CONTAINER_NAME || true
                        docker rm $CONTAINER_NAME || true
                    fi
                """
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
    }
}
