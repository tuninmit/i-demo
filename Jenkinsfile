pipeline {
    agent any

    environment {
        IMAGE_NAME = "i"
        IMAGE_TAG = "v1.0"
    }
	

    stages {
        stage('Checkout') {
            steps {
                script {
                    checkout scm
                }
            }
        }

        stage('Build Docker Image') {
			steps {
                withCredentials([
                    usernamePassword(credentialsId: 'NEXUS_ACCESS',
                    usernameVariable: 'username',
                    passwordVariable: 'password')
                ]) {
                    sh "docker build -t rdrepo.vnpt-technology.vn:7890/$IMAGE_NAME:$IMAGE_TAG ."
                    sh "docker login --username ${username} --password ${password} rdrepo.vnpt-technology.vn:7890"
                  	sh "docker push rdrepo.vnpt-technology.vn:7890/$IMAGE_NAME:$IMAGE_TAG"
                    
                }
            }
        }
    }

    post {
        always {
            sh "docker rmi rdrepo.vnpt-technology.vn:7890/$IMAGE_NAME:$IMAGE_TAG || true"
        }
    }
}
