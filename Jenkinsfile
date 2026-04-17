@Library('my-infra-lib') _
pipeline {
    agent {
        label 'Dev'
    }
    stages {
        stage ('checking the software') {
            steps {
                sh '''
                terraform version
                packer version
                aws --version
                ansible --version
                '''
            }
        }
        stage ('Building AMI'){
            steps {
                packerbuild()
            }
        }
    }
}