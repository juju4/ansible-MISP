// Work in progress

node {

    try{
        currentBuild.result = "SUCCESS"

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

    catch(err) {
        currentBuild.result = "FAILURE"
        throw err
    }
}
