def call() {
    timeout(time: 1, unit: 'HOURS') {
        input message: 'Approve the deployment?', ok: 'Proceed'
    }
}
