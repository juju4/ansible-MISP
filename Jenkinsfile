// Work in progress

node {

    try{
        currentBuild.result = "SUCCESS"
        def workspace = pwd()
        def directory = sh (
            script: 'echo ${GIT_URL##*/}',
            returnStdout: true
            ).trim()

        stage("Download source and capture commit ID") {
            sh "mkdir $directory"
            dir("$directory") {
                checkout scm
                // Get the commit ID
                sh 'git rev-parse --verify HEAD > GIT_COMMIT'
                git_commit = readFile('GIT_COMMIT').take(7)
                echo "Current commit ID: ${git_commit}"
            }
        }

        dir("$directory") {

            stage("Get dependencies"){
                sh "sh -x get-dependencies.sh"
            }
            stage("Build1"){
                defaultplatform = sh (
                    script: 'kitchen list | awk "!/Instance/ {print \$1; exit}"',
                    returnStdout: true
                    ).trim()
                sh "kitchen test ${defaultplatform}"
            }
            stage("Build all platforms"){
                sh "kitchen test"
            }

/*
            stage("Run security tests"){
            }

            stage("Run performance tests"){
            }

            stage("Create packer images"){
            }

            stage("Deploy"){
            }
*/
        }

    }

    catch(err) {
        currentBuild.result = "FAILURE"
        throw err
    }
}
