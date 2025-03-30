# Jenkins Master-Slave Architecture Setup

## Introduction
This guide provides step-by-step instructions to set up a Jenkins Master-Slave architecture. In this setup:
- **Jenkins Master** handles job scheduling and user interactions.
- **Jenkins Slave (Agent)** executes jobs based on the Master’s instructions.

## Prerequisites
- A running **Jenkins Master (EC2 instance)**.
- A configured **Slave (EC2 instance)**.
- Java installed on both Master and Slave.
- Jenkins plugins for SSH (if required).
- Follow this guide to install Jenkins and Java: [Java_Jenkins_Docker_Setup_AWS](https://github.com/Abhishek-2502/Java_Jenkins_Docker_Setup_AWS)

## Step 1: Configure Jenkins Master

1. Log in to Jenkins Master.
2. Navigate to **Manage Jenkins** -> **Nodes**.
3. Click **New Node**.
4. Enter the node name: `Cloudsim-Frontend-Slave`.
5. Select **Permanent Agent** and click **Create**.

## Step 2: Configure Node (Slave)

### General Settings:
- **Description**: `This is for Cloud Algorithm Simulator Frontend.`
- **Number of Executors**: `1` (Since t2.micro has 1 processor)
- **Remote Root Directory**: `/home/ubuntu/Cloud_Algorithm_Simulator_Frontend`
- **Labels**: `cloudsimFrontend`
- **Usage**: `Use this node as much as possible`

### Launch Method:
1. Select **Launch agents via SSH**.
2. Provide the following details:
   - **Host**: Public IP of Slave EC2 instance.
   - **Credentials**:
     - **Domain**: `Global credentials (unrestricted)`
     - **Kind**: `SSH Username with private key`
     - **Scope**: `Global (Jenkins, nodes, items, all child items, etc)`
     - **ID**: `cloudsim-frontend-slave`
     - **Description**: `This is for Cloudsim Frontend Slave.`
     - **Username**: `ubuntu` (EC2 default username)
     - **Private Key**: Paste the private key from `-----BEGIN OPENSSH PRIVATE KEY-----` to `-----END OPENSSH PRIVATE KEY-----`. (From Step 3)

### Security and Availability:
- **Host Key Verification Strategy**: `Non verifying Verification Strategy`
- **Availability**: `Keep this agent online as much as possible`

## Step 3: Get SSH Key
To obtain the private key of the slave EC2 instance, follow Step 2 of this guide: [Node_Todo_App_Docker_Jenkins_FreeStyle](https://github.com/Abhishek-2502/Node_Todo_App_Docker_Jenkins_FreeStyle) 

## Step 4: Save and Test Connection
1. Click **Save**.
2. Go to the **Nodes** section and ensure `Cloudsim-Frontend-Slave` is online.
3. Run a test job on the slave node to verify the connection.

## Step 5: Setup Declarative Pipeline
Follow this guide to setup Project in Jenkins Master using Declarative Pipeline: [Django_Notes_App_Docker_Jenkins_Declarative](https://github.com/Abhishek-2502/Django_Notes_App_Docker_Jenkins_Declarative)

### Jenkins example Pipeline for Slave Node
Below is an example `Jenkinsfile` that deploys the **Cloud Algorithm Simulator Frontend** using Docker on the `cloudsimFrontend` slave:

```groovy
pipeline {
    agent { label 'cloudsimFrontend' }

    environment {
        DOCKER_IMAGE = 'flask-cloudsim-app'
        DOCKER_TAG = 'latest'
        CONTAINER_NAME = 'flask-cloudsim-container'
        SSH_CREDENTIALS_ID = 'cloudsim-frontend-slave' // This should match Jenkins credentials ID
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    echo 'Checking out code using SSH...'
                    checkout([
                        $class: 'GitSCM',
                        branches: [[name: 'main']],
                        userRemoteConfigs: [[
                            url: 'git@github.com:Abhishek-2502/Cloud_Algorithm_Simulator_Frontend.git',
                            credentialsId: "${SSH_CREDENTIALS_ID}"
                        ]]
                    ])
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
            }
        }

        stage('Stop and Remove Existing Container') {
            steps {
                script {
                    sh "docker ps -a -q --filter 'name=${CONTAINER_NAME}' | xargs -r docker stop"
                    sh "docker ps -a -q --filter 'name=${CONTAINER_NAME}' | xargs -r docker rm"
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                sh "docker run -d -p 5000:5000 --name ${CONTAINER_NAME} ${DOCKER_IMAGE}:${DOCKER_TAG}"
            }
        }
    }

    post {
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed. Please check the logs.'
        }
    }
}
```

## Author
Abhishek Rajput

