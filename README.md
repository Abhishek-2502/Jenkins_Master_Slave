# Jenkins Master-Slave Architecture Setup

## Introduction
This guide provides step-by-step instructions to set up a Jenkins Master-Slave architecture. In this setup:
- **Jenkins Master** handles job scheduling and user interactions.
- **Jenkins Slave (Agent)** executes jobs based on the Master’s instructions.

## Prerequisites
- A running **Jenkins Master (EC2 instance)**.
- A configured **Slave (EC2 instance)**.
- Java installed on both Master and Slave.
- Docker and Docker-Compose on Slave.
- Follow this guide to install Jenkins, Java, Docker and Docker-Compose: [Java_Jenkins_Docker_Setup_AWS](https://github.com/Abhishek-2502/Java_Jenkins_Docker_Setup_AWS)

## Step 1: Configure Jenkins Master

1. Log in to Jenkins Master.
2. Navigate to **Manage Jenkins** -> **Nodes**.
3. Click **New Node**.
4. Enter the node name: `Master-Slave`.
5. Select **Permanent Agent** and click **Create**.

## Step 2: Configure Node (Slave)

### General Settings:
- **Description**: `This node is for Master Slave Architecture Testing.`
- **Number of Executors**: `1` (Since t2.micro has 1 processor)
- **Remote Root Directory**: `/home/ubuntu/`
- **Labels**: `master_slave`
- **Usage**: `Use this node as much as possible`

### Launch Method:
1. Select **Launch agents via SSH**.
2. Provide the following details:
   - **Host**: Public IP of Slave EC2 instance.
   - **Credentials**:
     - **Domain**: `Global credentials (unrestricted)`
     - **Kind**: `SSH Username with private key`
     - **Scope**: `Global (Jenkins, nodes, items, all child items, etc)`
     - **ID**: `master-slave`
     - **Description**: `This is private ID of Jenkins master.`
     - **Username**: `ubuntu` (EC2 default username)
     - **Private Key**: Paste the private key of Jenkins master from `-----BEGIN OPENSSH PRIVATE KEY-----` to `-----END OPENSSH PRIVATE KEY-----`. (From Step 3)

### Security and Availability:
- **Host Key Verification Strategy**: `Non verifying Verification Strategy`
- **Availability**: `Keep this agent online as much as possible`

## Step 3: Get SSH Key (ed25519)
To obtain the ed25519 private and public key of the EC2 instance,

### 1. **Generate SSH Key on Jenkins Master**
```bash
ssh-keygen -t ed25519 -C "abhishek25022004@gmail.com"
```

### 2. **Move Keys to Jenkins Directory**
```bash
sudo cp ~/.ssh/id_ed25519* /var/lib/jenkins/.ssh/
```

### 3. **Add GitHub to Known Hosts**
```bash
sudo ssh-keyscan github.com | sudo tee -a /var/lib/jenkins/.ssh/known_hosts
```

### 4. **Set Permissions**
```bash
sudo chown -R jenkins:jenkins /var/lib/jenkins/.ssh
sudo chmod 700 /var/lib/jenkins/.ssh
sudo chmod 600 /var/lib/jenkins/.ssh/id_ed25519
sudo chmod 644 /var/lib/jenkins/.ssh/id_ed25519.pub known_hosts
```

### 5. **Restart Jenkins**
```bash
sudo systemctl restart jenkins
```

### 6. **Use Keys**
- Add public key (`cat ~/.ssh/id_ed25519.pub`) to **GitHub SSH and GPG Keys in Settings**.
- Add private key (`cat ~/.ssh/id_ed25519`) in **Jenkins Credentials of Step 2**.

## Step 4: Save and Test Connection
1. Click **Save**.
2. Go to the **Nodes** section and ensure it is online.
3. Run a test job on the slave node to verify the connection.
4. Use git repo link while setting Jenkins as:
```bash
git@github.com:Abhishek-2502/Jenkins_Master_Slave.git
```

## Step 5: Setup Declarative Pipeline
Follow this guide to setup Project in Jenkins Master using Declarative Pipeline: [Django_Notes_App_Docker_Jenkins_Declarative](https://github.com/Abhishek-2502/Django_Notes_App_Docker_Jenkins_Declarative)

## Author
Abhishek Rajput

