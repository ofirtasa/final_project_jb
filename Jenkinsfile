pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS_ID = 'dockerhub-credentials' // Jenkins credentials ID
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

                    // Run Docker build using the Dockerfile in the cloned repo
                    sh "docker build -t ${latestTag} -t ${buildTag} ."
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials' , usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        sh """
                        echo "${PASSWORD}" | docker login -u "${USERNAME}" --password-stdin
                        docker push ${IMAGE_NAME}:latest
                        docker push ${IMAGE_NAME}:${BUILD_NUMBER}
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
