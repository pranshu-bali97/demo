def call(String status, String channel) {
    if (status == 'SUCCESS') {
        slackSend channel: 'pre-prod', message: 'Success'
    } else {
        slackSend channel: 'pre-prod', message: 'Fail'
    }
}
