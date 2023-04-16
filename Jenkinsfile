pipeline {
    agent any

    environment {
       registryCredential = 'ecr:us-east-1:awscreds'
       appRegistry        = "841043022779.dkr.ecr.us-east-1.amazonaws.com/sscademyappimg"
       sscademyRegistry   = "https://841043022779.dkr.ecr.us-east-1.amazonaws.com"
       cluster            = "Devcluster"
       service            = "sscademyappsvc"
    }
    tools {
        maven "MAVEN3"
        jdk "OracleJDK8"
    }

    stages {
        stage('Fetch code from VCS') {
            steps {
                git branch: 'main', credentialsId: 'gitsshkeynew', url: 'git@github.com:QuadriDevOps1/Jenkinstrigger.git'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn install -DskipTests'
            }
            post {
                success {
                    echo 'Now archiving the artifact...'
                    archiveArtifacts artifacts: '**/target/*.war'
                }
            }
        }

        stage('UNIT TEST') {
            steps {
                sh 'mvn test'
            }
        }
        
        stage('Checkstyle analysis') {
            steps {
                sh 'mvn checkstyle:checkstyle'
            }
        }

        stage('Sonar Analysis') {
            environment {
                scannerHome = tool 'sonar4.8'
            }
            steps {
                withSonarQubeEnv('sonar') {
                    sh '''${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=sscademy \
                    -Dsonar.projectName=sscademy-repo \
                    -Dsonar.projectVersion=1.0 \
                    -Dsonar.sources=src/ \
                    -Dsonar.java.binaries=target/test-classes/com/visualpathit/account/controllerTest/ \
                    -Dsonar.junit.reportsPath=target/surefire-reports/ \
                    -Dsonar.jacoco.reportsPath=target/jacoco.exec \
                    -Dsonar.java.checkstyle.reportPaths=target/checkstyle-result.xml'''
                }
            }
        }

        stage('Build App Image') {
            steps {
                script {
                    dockerImage = docker.build(appRegistry + ":$BUILD_NUMBER", "./")
                }
            }
        }
        
        stage('Push Docker Image') {
            steps{
                script {
                    docker.withRegistry( sscademyRegistry, registryCredential ) {
                        dockerImage.push("$BUILD_NUMBER") 
                        dockerImage.push('latest')
                    }
                }
            }
        }

        // stage('Deploy to Kubernetes Cluster') {
        //     agent {label 'KOPS'}
        //     steps {
        //         // Update Kubernetes manifest to use ECR image
        //         script {
        //             def manifestPath = "./kubernetes/app/appdep.yml"
        //             def ecrImage = "${BUILD_NUMBER}"
                    
        //             // Replace image in Kubernetes manifest
        //             sh "sed -i 's#<IMAGE_NAME>#${ecrImage}#' ${manifestPath}"
                    
        //             // Apply updated manifest to Kubernetes cluster
        //             sh "kubectl create namespace prod"
        //             sh "kubectl apply -f ${manifestPath} -n prod"
        //         }
        //     }


            stage('Deploy to Kubernetes Cluster') {
                agent {label 'KOPS'}
                    steps {
                       sh "helm upgrade --install --force sscademy-stack helm/sscademychart --set appimage=${appRegistry}:${BUILD_NUMBER} --namespace prod --create-namespace"
                }
            }
        
            }
        // }
}
    
