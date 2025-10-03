pipeline {
    agent any

    environment {
        // DockerHub repository (change if needed)
        DOCKER_REPO = "cdtsbikaner/devopstgmay2025"
    }

    stages {
        stage('Git Checkout') {
            steps {
                git(
                    branch: 'master',
                    url: 'https://github.com/cdtsbikaner/mycicdtest.git'
                )
            }
        }

        stage('Build & Push Docker Image') {
            steps {
                script {
                    // Build Docker image
                    sh "docker build -t ${DOCKER_REPO}:latest ."

                    // Push Docker image to repository
                    sh "docker push ${DOCKER_REPO}:latest"
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully!"
        }
        failure {
            echo "Pipeline failed!"
        }
    }
}
