pipeline {
    agent any

    environment {
        // DockerHub credentials stored in Jenkins as "dockerhub-creds"
        DOCKERHUB_CREDS = credentials('dockerhub-token')
        // DockerHub repository (change to your repo)
        DOCKER_REPO = "cdtsbikaner/devopstgmay2025"
    }

    stages {

        stage('Git Checkout') {
            steps {
                git branch: 'master',
                    url: 'https://github.com/cdtsbikaner/mycicdtest.git'
            }
        }

        stage('Build & Push Docker Image') {
            steps {
                script {
                    def imageTag = "${DOCKER_REPO}:${JOB_NAME}-${BUILD_NUMBER}"

                    echo "Building Docker image: ${imageTag}"

                    sh """
                        docker build -t ${imageTag} --no-cache .
                        echo ${DOCKERHUB_CREDS_PSW} | docker login -u ${DOCKERHUB_CREDS_USR} --password-stdin
                        docker push ${imageTag}
                    """
                }
            }
        }

        stage('Update Deployment File') {
            steps {
                script {
                    echo "Updating Kubernetes manifest with JobName=${JOB_NAME}, BuildNumber=${BUILD_NUMBER}"

                    sh """
                        sed -i "s/BUILD_NUMBER/${BUILD_NUMBER}/g" deployment.yaml
                        sed -i "s/prname/${JOB_NAME}/g" deployment.yaml
                    """
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    withKubeConfig([credentialsId: 'k8s-admin-file', serverUrl: 'https://172.31.86.126:6443']) {
                        sh """
                            kubectl apply -f service.yaml
                            kubectl apply -f deployment.yaml
                        """
                    }
                }
            }
        }
    }

    post {
        success {
            echo "✅ Build, Push, and Deployment successful!"
        }
        failure {
            echo "❌ Pipeline failed. Please check logs."
        }
    }
}
