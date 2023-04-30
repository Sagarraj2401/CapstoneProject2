# CapstoneProject2
DevOps Capstone Project2
Terraform Installation : 

wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
 

--------------- main.tf --------------------------------

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region  = "us-west-1"
  access_key = ""
  secret_key = ""
}


resource "aws_instance" "example" {
  ami = "ami-014d05e6b24240371"
  count = 1
  instance_type = "t2.medium"
  key_name = "Project2"
  tags = {
    Name = "kub-s"
  }
}
resource "aws_instance" "main" {
  ami = "ami-014d05e6b24240371"
  count = 1
  instance_type = "t2.medium"
  key_name = "Project2"
  tags = {
     Name = "kub1-master"
  }
}

=================
1. save file
2. terraform init
3. terraform plan --> to check the resource count which we are adding.
4. terraform apply
5. Now, instances will be created as per above file main.tf
 

-----------------------------------------------------------

Jenkins Installation : 

Install Java --> sudo apt install openjdk-11-jdk -y 
use this site to see how to install jenkins --> https://www.jenkins.io/doc/book/installing/linux/#debianubuntu

Copy below code
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins

Check status --> sudo service jenkins status

===========
1. Terraform installation on machine1
2. Java Installation on Machine1
3. Jenkins Installation on Machine1
4. Java Installed on Machine2 (Master)
5. Add Node in Jenkins (Master)
6. 

----------------------------------------------------------------------

K8s Installation 


Kubeadm 

sudo apt update -y
sudo apt install docker.io -y

sudo systemctl start docker
sudo systemctl enable docker

sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt update -y
sudo apt install kubeadm=1.20.0-00 kubectl=1.20.0-00 kubelet=1.20.0-00 -y

Master Node 

sudo su
hostnamectl set-hostname master
exec bash

kubeadm init (this will generate the join token command which needs to be executed on the worker node)

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Deploy CNI

--> kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml

kubectl get nodes -w

Worker Node

sudo su
hostnamectl set-hostname worker
exec bash


----------------------------------------------------------------------------------------------------

Jenkins Pipeline 

pipeline{
    agent none
    environment {
        DOCKERHUB_CREDENTIALS=credentials('8d0c490d-0928-4bd7-b8e7-42e5f54bb87f')
    }
    stages{
        stage('Hello'){
            agent{ 
                label 'K8sMaster'
            }
            steps{
                echo 'Hello World'
            }
        }
       
        stage('git'){
            agent{ 
                label 'K8sMaster'
            }

            steps{

                git'https://github.com/intellipaat2/website.git'
            }
        }
        stage('docker') {
            agent { 
                label 'K8sMaster'
            }

            steps {

                sh 'sudo docker build /home/ubuntu/jenkins/workspace/pipelinejob -t amanintellipaat/project2'
                sh 'sudo echo $DOCKERHUB_CREDENTIALS_PSW | sudo docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                sh 'sudo docker push amanintellipaat/project2'

            }
        }
         stage('Kuberneets') {
            agent { 
                label 'Kube Master'
            }

            steps {

                sh ' kubectl create -f deploy.yml'
                sh ' kubectl create -f svc.yml'
            }
        }

    }
}

-------------------------------------------------------------------------

Dockerfile , Deploy yaml , SVC yaml : https://github.com/intellipaat2/website


