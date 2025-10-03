pipeline {
    agent any

    environment {
        DOCKER_REPO = "cdtsbikaner/devopstgmay2025"
        IMAGE_TAG = "latest"

        // Credentials exposed as environment variables
        GIT_USERNAME = credentials('github-token')  // GitHub username/token
        DOCKER_USER = credentials('dockerhub-token') // DockerHub username/token
    }

    stages {
        stage('Checkout Code') {
            steps {
                sh 'git clone https://$GIT_USERNAME@github.com/cdtsbikaner/mycicdtest.git'
            }
        }

        stage('Docker Login') {
            steps {
                sh 'echo $DOCKER_USER | docker login -u $DOCKER_USER --password-stdin'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_REPO}:${IMAGE_TAG} ."
            }
        }

        stage('Push Docker Image') {
            steps {
                sh "docker push ${DOCKER_REPO}:${IMAGE_TAG}"
            }
        }
    }

    post {
        success { echo "✅ Pipeline completed successfully!" }
        failure { echo "❌ Pipeline failed!" }
    }
}
