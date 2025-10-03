pipeline {
    agent any
    parameters {
        string(name: 'DOCKER_TAG', description: 'Enter the tag for the image', defaultValue: 'latest')
    }
    stages {
        stage('Git Checkout') {
            steps {
                // This stage is to get the Dockerfile
                git branch: 'master',
                    url: 'https://github.com/cdtsbikaner/mycicdtest.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    // Make sure that Docker is installed and configured before reaching here
         		 docker build -t cdtsbikaner/devopstgmay2025:${JOB_NAME}-${BUILD_NUMBER}  --no-cache  .
	        	 docker image push cdtsbikaner/devopstgmay2025:${JOB_NAME}-${BUILD_NUMBER}
                    }
                }
            }
        }
		
        stage("Update Tag in deployment.yml") {
            steps {
                script {
                 sed -i  "s/BUILD_NUMBER/${BUILD_NUMBER}/g"  tomcat-deploy.yaml
				         sed -i  "s/prname/${JOB_NAME}/g"  tomcat-deploy.yaml
                }
            }
        }
        stage("Deploy on Kubernetes") {
            steps {
                script {
                    withKubeConfig([credentialsId: 'k8s-admin-file', serverUrl: 'https://172.31.86.126:6443']) {
                        sh "kubectl apply -f service.yaml"
						            sh "kubectl apply -f deployment.yaml"
                    }
                }
            }
        }
    }
}
