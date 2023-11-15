pipeline {
    agent any

    environment {
        // 환경 변수 설정
        NCR_REPOSITORY = '0c0aedbf-kr1-registry.container.nhncloud.com/nh-reg'
        DOCKER_IMAGENAME = 'nh-web'
        IMAGE_TAG = 'latest'
    }

    stages {
        stage('Checkout') {
            steps {
                // GitHub 저장소에서 소스 코드 체크아웃
                git branch: 'main', url: 'https://github.com/kolion98/TestWeb.git'
            }
        }
      
        stage('Docker Login') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'nhncloud-credentials', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                        sh "sudo docker login $NCR_REPOSITORY -u $DOCKER_USERNAME -p $DOCKER_PASSWORD"                            
                    }
                }
            }
        }

        stage('Build & Push Docker Images') {
            steps {
              script {
                sh 'cd "/home/ubuntu/dev/TestWeb"'                  
                sh 'sudo docker build -t $DOCKER_IMAGENAME:$IMAGE_TAG .'
                sh 'sudo docker tag $DOCKER_IMAGENAME:$IMAGE_TAG $NCR_REPOSITORY/$DOCKER_IMAGENAME:$IMAGE_TAG'
                sh 'sudo docker push $NCR_REPOSITORY/$DOCKER_IMAGENAME:$IMAGE_TAG'
              }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh 'cd "/home/ubuntu/dev/TestWeb/cicd"' 
                    def kubeconfigPath = '/home/ubuntu/dev/TestWeb/cicd/nh-pro-nks_kubeconfig.yaml'
                    // KUBECONFIG 환경 변수 설정 (등호 양 옆에 공백이 없도록 주의)
                    withEnv(["KUBECONFIG=$kubeconfigPath"]) {
                        // Kubernetes 클러스터에 Deployment 적용
                        sh 'kubectl apply -f /home/ubuntu/dev/TestWeb/cicd/testweb-deployment.yaml'
                    }
                }
            }
        }
    }

    post {
        always {
            // 항상 실행되는 작업, 예를 들어 클린업
            echo '이 작업은 실행 결과에 상관없이 항상 실행됩니다.'
        }
        success {
            // 빌드 성공 시 실행되는 작업
            echo '이 작업은 빌드가 성공하면 실행됩니다.'
        }
        failure {
            // 빌드 실패 시 실행되는 작업
            echo '이 작업은 빌드가 실패하면 실행됩니다.'
        }
    }
}
