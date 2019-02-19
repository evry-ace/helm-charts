#!groovy
@Library("ace") _

properties([disableConcurrentBuilds()])

def isMaster = "${env.BRANCH_NAME}" == 'master'
def isPR = "${env.CHANGE_URL}".contains('/pull/')

opts = [
  dockerSet: false,
  buildAgent: 'jenkins-docker-3',
  // workspace: '/opt/bitnami/apps/jenkins'
]

ace(opts) {
  stage("Init") {
  }

  stage("Test") {
    slack.notifySuccessful()
  }
}
