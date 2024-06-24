pipeline {
    agent any 

    environment {
        DOCKER_IMAGE_BACKEND = "aravindnali51/backend:${env.BUILD_ID}"
        DOCKER_IMAGE_FRONTEND = "aravindnali51/frontend:${env.BUILD_ID}"
        AWS_DEFAULT_REGION = 'us-west-2'
        TF_IN_AUTOMATION = 'true'
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/aravindnali1997/spring-boot-react-example.git'
            }
        }

        stage('Build Backend') {
            steps {
                dir('backend') {
                    bat 'mvnw.cmd clean package -DskipTests'
                }
            }
            post {
                always {
                    archiveArtifacts artifacts: 'backend\\target\\*.jar', allowEmptyArchive: true
                }
            }
        }

        stage('Test Backend') {
            steps {
                dir('backend') {
                    bat 'mvnw.cmd test'
                }
            }
        }

        stage('Build Frontend') {
            steps {
                dir('frontend') {
                    bat 'npm install'
                    bat 'npm run build'
                }
            }
        }

        stage('Test Frontend') {
            steps {
                dir('frontend') {
                    bat 'npm test'
                }
            }
        }

        stage('Build Docker Images') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE_BACKEND}", '-f backend/Dockerfile .').push()
                    docker.build("${DOCKER_IMAGE_FRONTEND}", '-f frontend/Dockerfile .').push()
                }
            }
        }

        stage('Deploy Infrastructure') {
            steps {
                dir('infra') {
                    bat 'terraform init'
                    bat 'terraform apply -auto-approve'
                }
            }
        }

        stage('Deploy Application') {
            steps {
                echo 'Deploying application to cloud...'
                // Add your deployment scripts here
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
