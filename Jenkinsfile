// Work in progress

node {

    try{
        currentBuild.result = "SUCCESS"
        def workspace = pwd()
        //def git_url = build.getEnvironment(listener).get('GIT_URL')
        //def directory = git_url.substring(input.lastIndexOf("/") + 1)
        def directory = "MISP"

        stage 'Clean Workspace'
            deleteDir()

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
            stage("Build and verify 1"){
                sh 'git config --get remote.origin.url > GIT_REMOTE_ORIGIN_URL'
                git_url2 = readFile('GIT_REMOTE_ORIGIN_URL')
                echo "Current Git url2: ${git_url2}"

                defaultplatform = sh (
                    script: 'kitchen list | awk \\"!/Instance/ {print \\\\\$1; exit}\\"',
                    returnStdout: true
                    ).trim()
                sh 'kitchen list | awk \\"!/Instance/ {print \\\\\$1; exit}\\" > KITCHEN_DEFAULT_PLATFORM'
                defaultplatform2 = readFile('KITCHEN_DEFAULT_PLATFORM')
                echo "default platform: ${defaultplatform}"
                echo "default platform2: ${defaultplatform2}"

                sh "kitchen test ${defaultplatform}"
            }
            stage("Build and verify all platforms"){
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
