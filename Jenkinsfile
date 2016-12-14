// Work in progress

node {

    try{
        currentBuild.result = "SUCCESS"
        def workspace = pwd()
        def git_url = env.GIT_URL
        //def git_url = build.getEnvironment(listener).get('GIT_URL')
        //def directory = git_url.substring(input.lastIndexOf("/") + 1)
        def directory = "MISP"

        stage("Download source and capture commit ID") {
            sh "mkdir $directory"
            dir("$directory") {
                checkout scm
                // Get the commit ID
                sh 'git rev-parse --verify HEAD > GIT_COMMIT'
                git_commit = readFile('GIT_COMMIT').take(7)
                echo "Current commit ID: ${git_commit}"
                echo "Current Git url: ${git_url}"
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
