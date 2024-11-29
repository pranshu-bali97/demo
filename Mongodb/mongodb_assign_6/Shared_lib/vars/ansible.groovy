def call() {
    ansiblePlaybook credentialsId: '67566dc8-069e-4c59-8308-aac784619a7b', installation: 'Ansible', inventory: 'resources/aws_ec2.yml', playbook: 'resources/playbook.yml', vaultTmpPath: ''
}
