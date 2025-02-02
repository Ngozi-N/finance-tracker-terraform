pipeline {
    agent any

    environment {
        AWS_REGION = "eu-west-2"
        AWS_ACCESS_KEY_ID = credentials('aws-access-key')  // Stored in Jenkins credentials
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')  // Stored in Jenkins credentials
        DOCKER_HUB_USERNAME = "ngozin"
        DOCKER_HUB_PASSWORD = credentials('docker-hub-password')  // Stored in Jenkins credentials
        S3_BACKEND_REPO = "https://github.com/Ngozi-N/finance-tracker-s3-backend-setup.git"
        TERRAFORM_REPO = "https://github.com/Ngozi-N/finance-tracker-terraform.git"
        FRONTEND_REPO = "git@github.com:Ngozi-N/finance-tracker-frontend.git"
        BACKEND_REPO = "git@github.com:Ngozi-N/finance-tracker-backend.git"
        KUBERNETES_REPO = "git@github.com:Ngozi-N/finance-tracker-kubernetes.git"
        TERRAFORM_DIR = "terraform"
        S3_BACKEND_DIR = "s3-backend"
        KUBE_NAMESPACE = "finance-tracker"
    }

    stages {
        stage('Clone S3 Backend Repository') {
            steps {
                script {
                    sh "rm -rf ${S3_BACKEND_DIR}"
                    sh "git clone ${S3_BACKEND_REPO} ${S3_BACKEND_DIR}"
                }
            }
        }

        stage('Deploy S3 Backend for Terraform State') {
            steps {
                dir("${S3_BACKEND_DIR}") {
                    script {
                        sh "terraform init"
                        sh "terraform apply -auto-approve"
                    }
                }
            }
        }
        
        stage('Clone Terraform Repository') {
            steps {
                script {
                    sh "rm -rf ${TERRAFORM_DIR}"
                    sh "git clone ${TERRAFORM_REPO} ${TERRAFORM_DIR}"
                }
            }
        }

        stage('Terraform Init & Apply') {
            steps {
                dir("${TERRAFORM_DIR}") {
                    script {
                        sh "terraform init"
                        sh "terraform apply -auto-approve"
                    }
                }
            }
        }

        stage('Extract Terraform Outputs') {
            steps {
                dir("${TERRAFORM_DIR}") {
                    script {
                        def outputs = sh(script: "terraform output -json", returnStdout: true).trim()
                        writeFile file: 'terraform_outputs.json', text: outputs
                        echo "Terraform outputs saved!"
                    }
                }
            }
        }

        stage('Setup SSH for GitHub') {
            steps {
                script {
                    sh """
                        mkdir -p ~/.ssh
                        chmod 700 ~/.ssh
                        ssh-keyscan github.com >> ~/.ssh/known_hosts
                        chmod 644 ~/.ssh/known_hosts
                        eval \$(ssh-agent -s)
                        ssh-add ~/.ssh/id_rsa
                        export GIT_SSH_COMMAND='ssh -o StrictHostKeyChecking=no'
                    """
                }
            }
        }

        
        stage('Clone Application Repositories') {
            steps {
                script {
                    sh "rm -rf frontend backend kubernetes"
                    sh "git clone ${FRONTEND_REPO} frontend"
                    sh "git clone ${BACKEND_REPO} backend"
                    sh "git clone ${KUBERNETES_REPO} kubernetes"
                }
            }
        }

        stage('Build & Push Backend Docker Image') {
            steps {
                dir('backend') {
                    script {
                        withCredentials([string(credentialsId: 'docker-hub-password', variable: 'DOCKER_HUB_PASSWORD')]) {
                            sh """
                                echo "\$DOCKER_HUB_PASSWORD" | docker login -u "${DOCKER_HUB_USERNAME}" --password-stdin
                                docker build -t ${DOCKER_HUB_USERNAME}/finance-tracker-backend:latest .
                                docker push ${DOCKER_HUB_USERNAME}/finance-tracker-backend:latest
                            """
                        }
                    }
                }
            }
        }

        stage('Build & Push Frontend Docker Image') {
            steps {
                dir('frontend') {
                    script {
                        withCredentials([string(credentialsId: 'docker-hub-password', variable: 'DOCKER_HUB_PASSWORD')]) {
                            sh """
                                echo "\$DOCKER_HUB_PASSWORD" | docker login -u "${DOCKER_HUB_USERNAME}" --password-stdin
                                docker build -t ${DOCKER_HUB_USERNAME}/finance-tracker-frontend:latest .
                                docker push ${DOCKER_HUB_USERNAME}/finance-tracker-frontend:latest
                            """
                        }
                    }
                }
            }
        }

        stage('Authenticate kubectl with EKS') {
            steps {
                script {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]) {
                        sh """
                            aws eks update-kubeconfig --region eu-west-2 --name finance-tracker-eks
                            kubectl get nodes  # Check if kubectl is authenticated
                        """
                    }
                }
            }
        }

        stage('Create Kubernetes Namespace') {
            steps {
                script {
                    sh """
                        kubectl create namespace ${KUBE_NAMESPACE} --dry-run=client -o yaml | kubectl apply -f -
                        kubectl get namespace ${KUBE_NAMESPACE}  # Verify the namespace exists
                    """
                }
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                dir('kubernetes') {
                    script {
                        sh "kubectl apply -f backend/backend-deployment.yaml"
                        sh "kubectl apply -f backend/backend-service.yaml"
                        sh "kubectl apply -f frontend/frontend-deployment.yaml"
                        sh "kubectl apply -f frontend/frontend-service.yaml"
                        sh "kubectl apply -f ingress/ingress.yaml"
                        sh "kubectl apply -f configmap.yaml"
                        sh "kubectl apply -f namespace.yaml"
                        sh "kubectl apply -f secrets.yaml"
                    }
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                script {
                    sh "kubectl get pods -n ${KUBE_NAMESPACE}"
                    sh "kubectl get services -n ${KUBE_NAMESPACE}"
                }
            }
        }
    }
}
