pipeline {
    agent any

    environment {
        DOCKER_REPO = "cdtsbikaner/devopstgmay2025"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git(
                    url: 'https://github.com/cdtsbikaner/mycicdtest.git',
                    credentialsId: 'github-token',
                    branch: 'master'
                )
                // Save Git commit hash in environment variable
                script {
                    env.GIT_COMMIT_HASH = sh(
                        script: "git rev-parse --short HEAD",
                        returnStdout: true
                    ).trim()
                }
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
                sh """
                    docker build -t ${DOCKER_REPO}:latest -t ${DOCKER_REPO}:${GIT_COMMIT_HASH} .
                """
            }
        }

        stage('Push Docker Image') {
            steps {
                sh """
                    docker push ${DOCKER_REPO}:latest
                    docker push ${DOCKER_REPO}:${GIT_COMMIT_HASH}
                """
            }
        }

        stage('Use Kubernetes Secret (optional)') {
            steps {
                withCredentials([file(credentialsId: 'k8s-admin-file', variable: 'K8S_CONFIG')]) {
                    sh 'echo "Kubernetes secret available at $K8S_CONFIG"'
                    // Example for deployment:
                    // sh "kubectl --kubeconfig=$K8S_CONFIG apply -f deployment.yaml"
                }
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline completed successfully!"
            echo "Docker images pushed: ${DOCKER_REPO}:latest and ${DOCKER_REPO}:${GIT_COMMIT_HASH}"
        }
        failure {
            echo "❌ Pipeline failed!"
        }
    }
}
