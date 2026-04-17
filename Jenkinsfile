@Library('my-infra-lib') _
pipeline {
    agent {
        label 'Dev'
    }
    parameters {
        choice(name: 'PACKER_BUILD', choices: ['no', 'yes'], description: 'Choose an action')
        string(name: 'REGION', defaultValue: 'ap-south-2', description: 'Provide Region')
        choice(name: 'TERRAFORM_APPLY', choices: ['no', 'yes'], description: 'Choose an action')
        choice(name: 'TERRAFORM_DESTROY', choices: ['no', 'yes'], description: 'Choose an action')
        choice(name: 'Ansible_Build', choices: ['no', 'yes'], description: 'Choose an action')   
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
            when {
                    expression { return params.PACKER_BUILD =='yes'}
                }
            steps {
                packerbuild()
            }
        }
        stage('Update AMI ID In Vars'){
             steps {
                latestami(params.REGION)
            }
        }
        stage('Terraform_Plan') {
            steps{
                terraformplan()
            }
        }
        stage('Terraform_Apply'){
                when{
                expression { return params.TERRAFORM_APPLY == 'yes' }
            }
            steps{
                sh 'terraform apply --auto-approve'
            }
        }
        stage('Terraform_Destory'){
            when{
                expression { return params.TERRAFORM_DESTROY == 'yes'}
            }
            steps {
                sh 'terraform init'
                sh 'terraform destory --auto-approve'
            }
        }
         stage('Ansible apply'){
             when{
                expression { return params.Ansible_Build == 'yes'}
            }
            steps{
                sh 'ansible-playbook -i invfile site.yaml --syntax-check'
                sh 'ansible-playbook -i invfile site.yaml --check'
            }
        }
    }
}