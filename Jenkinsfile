pipeline {
    agent any

    environment {
        DOCKER_REPO = "cdtsbikaner/devopstgmay2025"
        IMAGE_TAG = "latest"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git(
                    url: 'https://github.com/cdtsbikaner/mycicdtest.git',
                    credentialsId: 'github-token',
                    branch: 'master'
                )
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-token',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                }
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

        stage('Use Kubernetes Secret (optional)') {
            steps {
                withCredentials([file(credentialsId: 'k8s-admin-file', variable: 'K8S_CONFIG')]) {
                    sh 'echo "Kubernetes secret file is available at $K8S_CONFIG"'
                    // You can add kubectl commands here if needed, e.g.:
                    // sh "kubectl --kubeconfig=$K8S_CONFIG apply -f deployment.yaml"
                }
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline completed successfully!"
        }
        failure {
            echo "❌ Pipeline failed!"
        }
    }
}
