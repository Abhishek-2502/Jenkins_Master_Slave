# Jenkins Master-Slave Architecture Setup

## Introduction
This guide provides step-by-step instructions to set up a Jenkins Master-Slave architecture. In this setup:
- **Jenkins Master** handles job scheduling and user interactions.
- **Jenkins Slave (Agent)** executes jobs based on the Master’s instructions.

## Prerequisites
- A running **Jenkins Master Instance**.
- A configured **Slave Instance**.
- Java installed on both Master and Slave.
- Docker and Docker-Compose on Slave.
- Follow this guide to install Jenkins, Java, Docker and Docker-Compose: [Java_Jenkins_Docker_Setup_Cloud](https://github.com/Abhishek-2502/Java_Jenkins_Docker_Setup_Cloud)

## Step 1: Get SSH Key in Jenkins-Master (ed25519)
To obtain the ed25519 private and public key of the Jenkins-master instance,

### 1. **Generate SSH Key on Jenkins Master**
```bash
ssh-keygen -t ed25519 -C "abhishek25022004@gmail.com"
```
### 2. **Create SSH Folder**
```bash
sudo mkdir -p /var/lib/jenkins/.ssh
sudo chown jenkins:jenkins /var/lib/jenkins/.ssh
sudo chmod 700 /var/lib/jenkins/.ssh
```

### 3. **Move Keys to Jenkins Directory**
```bash
sudo cp ~/.ssh/id_ed25519* /var/lib/jenkins/.ssh/
```

### 4. **Add GitHub to Known Hosts**
```bash
sudo ssh-keyscan github.com | sudo tee -a /var/lib/jenkins/.ssh/known_hosts
```

### 5. **Add Slave to Known Hosts (Can skip now but will be implemented if Step 4.3 condition is applicable)**
```bash
sudo -u jenkins ssh-keyscan slave_public_ip | sudo tee -a /var/lib/jenkins/.ssh/known_hosts > /dev/null
```

### 6. **Set more Permissions**
```bash
sudo chmod 600 /var/lib/jenkins/.ssh/id_ed25519
sudo chmod 644 /var/lib/jenkins/.ssh/id_ed25519.pub /var/lib/jenkins/.ssh/known_hosts
```

### 7. **Restart Jenkins**
```bash
sudo systemctl restart jenkins
```

### 8. **Use Keys**
- Add public key (`cat ~/.ssh/id_ed25519.pub`) to **GitHub SSH and GPG Keys in Settings**.
- Add private key (`cat ~/.ssh/id_ed25519`) in **Credentials used for upcoming Declarative Pipeline (Step 5)**.


## Step 2: Configure Jenkins Master

1. Log in to Jenkins Master.
2. Navigate to **Manage Jenkins** -> **Nodes**.
3. Click **New Node**.
4. Enter the node name: `Master-Slave`.
5. Select **Permanent Agent** and click **Create**.

## Step 3: Configure Node (Slave)

### General Settings:
- **Description**: `This node is for Master Slave Architecture Testing.`
- **Number of Executors**: `1` (Since t2.micro has 1 processor)
- **Remote Root Directory**: `/home/foldername/` (**NOTE:** foldername can be found using **pwd** command)
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
     - **Description**: `This is private key of slave.`
     - **Username**: `username` (**NOTE:** username can be found using **whoami** command) (EC2 default username = ubuntu) 
     - **Private Key**: Paste the private key of slave from `-----BEGIN OPENSSH PRIVATE KEY-----` to `-----END OPENSSH PRIVATE KEY-----`. (Refer to **Step 2** of the guide: [Node_Todo_App_Docker_Jenkins_FreeStyle](https://github.com/Abhishek-2502/Node_Todo_App_Docker_Jenkins_FreeStyle))

### Security and Availability:
- **Host Key Verification Strategy**: `Non verifying Verification Strategy`
- **Availability**: `Keep this agent online as much as possible`

## Step 4: Save and Test Connection
1. Click **Save**.
2. Go to the **Nodes** section and ensure it is online.
3. If it is not online, then follow Step 4 and again check if it is online or not.
4. Run a test job on the slave node to verify the connection.

## Step 5: Setup Declarative Pipeline
Follow this guide to setup Project in Jenkins Master using Declarative Pipeline: [Django_Notes_App_Docker_Jenkins_Declarative](https://github.com/Abhishek-2502/Django_Notes_App_Docker_Jenkins_Declarative)

### NOTE:
- Use git repo link while setting Jenkins as if your repo is private:
```bash
git@github.com:Abhishek-2502/Jenkins_Master_Slave.git
```

## Author
Abhishek Rajput

