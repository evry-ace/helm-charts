#!groovy
@Library("ace") _

properties([
  [$class: 'BuildDiscarderProperty', strategy: [$class: 'LogRotator', artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '', numToKeepStr: '5']],
])
def isMaster = "${env.BRANCH_NAME}" == 'master'
def isPR = "${env.CHANGE_URL}".contains('/pull/')

opts = [
  dockerSet: false,
  buildAgent: 'jenkins-docker-3',
]

ace(opts) {

   kubectlImage = 'lachlanevenson/k8s-kubectl'
    kubectlVersion = 'v1.12.7'
   kubectlOpts = "--entrypoint=''"
    helmImage = 'lachlanevenson/k8s-helm'
    helmOpts = "--entrypoint=''"
    credId  = 'kubernetes.maze-test'
    credVar = 'KUBECONFIG'

  stage("Init") {
    lastCommitMessage = sh(returnStdout: true, script: "git log --format=format:%s -1")?.trim()
    println lastCommitMessage

    withCredentials([file(credentialsId: credId, variable: credVar)]) {
      docker.image(kubectlImage+':'+kubectlVersion).inside(kubectlOpts) {
          script = '''
            kubectl get pod -n kube-system -l app=helm,name=tiller \
              -o jsonpath="{ .items[0].spec.containers[0].image }" | cut -d ':' -f2
          '''
        helmVersion = sh(script: script, returnStdout: true)?.trim()

        println "Helm version discovered: ${helmVersion}"
      }
    }
  }

  stage("Lint") {
    withCredentials([file(credentialsId: credId, variable: credVar)]) {
      docker.image(helmImage + ':' + helmVersion).inside(helmOpts) {
        sh """
          set -u
          set -e
          # Set Helm Home
          export HELM_HOME=\$(pwd)
          # Install Helm locally
          helm init -c
          
          # Lint the charts
          helm lint web
          helm lint nodejs
          helm lint java
          helm lint golang
          helm lint dotnet
        """
      }
    }
  }

  stage("Dry run install") {
    withCredentials([file(credentialsId: credId, variable: credVar)]) {
      docker.image(helmImage + ':' + helmVersion).inside(helmOpts) {
        sh """
          set -u
          set -e
          # Set Helm Home
          export HELM_HOME=\$(pwd)
          # Install Helm locally
          helm init -c

          # Dry run install the charts
          helm install --dry-run --debug ./web
          helm install --dry-run --debug ./nodejs
          helm install --dry-run --debug ./java
          helm install --dry-run --debug ./golang
          helm install --dry-run --debug ./dotnet
        """
      }
    }
  }

  stage("Package charts") {
    withCredentials([file(credentialsId: credId, variable: credVar)]) {
      docker.image(helmImage + ':' + helmVersion).inside(helmOpts) {
        sh """
          set -u
          set -e
          # Set Helm Home
          export HELM_HOME=\$(pwd)

          # Install Helm locally
          helm init -c

          # Dry run install the charts
          helm package web -d release
          helm package nodejs -d release
          helm package java -d release 
          helm package golang -d release
          helm package dotnet -d release
          helm repo index .
        """
      }
    }
  }

  stage("Push charts") {
    if (isMaster && !lastCommitMessage.startsWith('AUTO-RELEASE:')) {
      releaseDate = sh(returnStdout: true, script: "date +%Y%m%d_%H%M%S").trim()
      sshagent (credentials: ['helm_chart_github_account']) {
        sh 'git config --global user.email "bgobuildserveradmin@evry.com"'
        sh 'git config --global user.name "BGOBuild ServerAdmin"'
        sh 'git remote add upload git@github.com:evry-ace/helm-charts.git'
        sh 'git add index.yaml'
        sh 'git add release/'
        sh 'git commit -am "AUTO-RELEASE: Updated version of charts"'
        sh 'git tag release-'+releaseDate
        sh 'git push --tags upload HEAD:master'

      }
    }
  }

  stage("Notify all") {
    
    slack.notifySuccessful()
  }
}
