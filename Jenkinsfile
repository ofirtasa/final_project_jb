pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS_ID = 'dockerhub_cred' // Jenkins credentials ID
        DOCKERHUB_USER = 'ofir2608'
        IMAGE_NAME = 'ofir2608/final_project_jb'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/ofirtasa/final_project_jb.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def buildNumber = env.BUILD_NUMBER
                    def latestTag = "${IMAGE_NAME}:latest"
                    def buildTag = "${IMAGE_NAME}:${buildNumber}"

                    powershell "docker --version"
                    // Run Docker build using the Dockerfile in the cloned repo
                    powershell "docker build -t ${latestTag} -t ${buildTag} ."
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub_cred' , usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        powershell """
                            docker login -u $env:USERNAME -p $env:PASSWORD
                            docker push ${env.IMAGE_NAME}:latest
                            docker push ${env.IMAGE_NAME}:${env.BUILD_NUMBER}
                        """
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Docker image built and pushed successfully!'
        }
        failure {
            echo 'Docker image build or push failed.'
        }
    }
}
