pipeline {
    agent any
    tools {nodejs "NODEJS"}
    stages {
        stage('Build') {
            steps {
                sh 'sudo npm install'
            }
        }
        stage('Deliver') {
            steps {
                sh 'sudo chmod -R +rwx ./jenkins/scripts/deliver.sh'
                sh 'sudo chmod -R +rwx ./jenkins/scripts/kill.sh'
                sh './jenkins/scripts/deliver.sh'
                input message: 'Finished using the web site? (Click "Proceed" to continue)'
                sh './jenkins/scripts/kill.sh'
            }
        }
    }
}