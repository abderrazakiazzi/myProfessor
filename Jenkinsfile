pipeline {
    agent any
    triggers {
        githubPush()
    }
    tools {
        nodejs "NODEJS"
    }
    stages {
        stage('Build') {
            steps {
                sh 'npm install'
            }
        }
        stage('Deliver') {
            steps {
                sh 'chmod -R +rwx ./jenkins/scripts/deliver.sh'
                sh 'chmod -R +rwx ./jenkins/scripts/kill.sh'
                sh './jenkins/scripts/deliver.sh'
                input message: 'Finished using the web site? (Click "Proceed" to continue)'
                sh './jenkins/scripts/kill.sh'
            }
        }
        stage('Test SSR') {
            steps {
                sh """
                # Vérifier que le serveur répond
                curl -s -o /dev/null -w "%{http_code}" http://localhost:$SSR_PORT
                """
            }
        }
    }
}