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

//                echo "Current Git url: ${git_url}"

//                sh 'git config --get remote.origin.url > GIT_REMOTE_ORIGIN_URL'
//                git_url2 = readFile('GIT_REMOTE_ORIGIN_URL')
//                echo "Current Git url2: ${git_url2}"

            }
        }

        dir("$directory") {

            stage("Get dependencies"){
                sh "sh -x get-dependencies.sh"
            }
            stage("Build and verify 1"){
                defaultplatform = sh (
//                    script: 'kitchen list | awk \\"!/Instance/ {print \\\\\$1; exit}\\"',
//                    script: 'kitchen list | awk \\"!/Instance/ {print; exit}\\"',
                    script: '''#!/bin/bash
kitchen list | awk "!/Instance/ {print \\$1; exit}"
                        ''',
                    returnStdout: true
                    ).trim()
                echo "default platform: ${defaultplatform}"

                sh "kitchen test ${defaultplatform}"
            }

            stage("Build and verify all platforms"){
                platforms = sh (
                    script: '''#!/bin/bash
kitchen list | awk "!/Instance/ && FNR>2 {print \\$1}"
                    ''',
                    returnStdout: true
                    ).trim()
                platformslist = platforms.split("\n").collect{it as string}

// https://jenkins.io/doc/pipeline/examples/#parallel-multiple-nodes
                def builders = [:]
                for (x in platformslist) {
                    def label = x // Need to bind the label variable before the closure - can't do 'for (label in labels)'

                    // Create a map to pass in to the 'parallel' step so we can fire all the builds at once
                    builders[label] = {
                      node(label) {
                        // build steps that should happen on all nodes go here
                        sh "kitchen test ${x}"
                      }
                    }
                }
                parallel builders
            }

            stage("Run security tests"){
                defaultplatform = sh (
                    script: '''#!/bin/bash
kitchen list | awk "!/Instance/ {print \\$1; exit}"
                        ''',
                    returnStdout: true
                    ).trim()
                echo "default platform: ${defaultplatform}"

                sh '''#!/bin/bash
## read ssh config from json .kitchen/{platform}.yml
f=.kitchen/${defaultplatform}.yml
if [ -f $f ]; then

    awk -F'[: ]' '/(hostname|username|ssh_key)/ { OFS=""; print $1,"=",$3 }' ${f} > /tmp/sshvars.$$
    . /tmp/sshvars.$$
    SSH_ARGS="-t ssh://${username}@${hostname}"
    [ -z "${ssh_key}" ] && ssh_key=$HOME/.ssh/id_rsa
    SSH_ARGS="$SSH_ARGS -i ${ssh_key/$HOME/\\/share}"
    DOCKER_ARGS="-v $HOME/.ssh:/share/.ssh:ro --read-only --tmpfs /run --tmpfs /tmp --tmpfs /root/.inspec"

## +user+readonly+tmpfs?
    docker pull chef/inspec
    docker run $DOCKER_ARGS -it --rm chef/inspec exec https://github.com/dev-sec/tests-ssh-hardening $SSH_ARGS
    docker run $DOCKER_ARGS -it --rm chef/inspec exec https://github.com/juju4/tests-os-hardening $SSH_ARGS
    docker run $DOCKER_ARGS -it --rm chef/inspec exec https://github.com/dev-sec/tests-apache-hardening $SSH_ARGS
    docker run $DOCKER_ARGS -it --rm chef/inspec exec https://github.com/dev-sec/tests-mysql-hardening

    DOCKER_ARGS="--read-only --tmpfs /run --tmpfs /tmp"
    docker pull uzyexe/nmap
    docker run --rm uzyexe/nmap -A ${hostname}

## https://github.com/andresriancho/w3af/commit/305e1670c9403d5f8265f11cc4c0813f768dc811
## Error while reading plugin options: "Invalid file option "~/output-w3af.csv"
    #DOCKER_ARGS="--read-only --tmpfs /run --tmpfs /tmp --tmpfs /home/w3af/.w3af -v $HOME/w3af-shared:/home/w3af/w3af/scripts:ro"
    DOCKER_ARGS="--tmpfs /run --tmpfs /tmp --tmpfs /home/w3af/.w3af -v $HOME/w3af-shared:/home/w3af/w3af/scripts:ro"
    docker pull andresriancho/w3af 
    mkdir ~/w3af-shared
    wget -q -O ~/w3af-shared/all.w3af https://github.com/andresriancho/w3af/raw/master/scripts/all.w3af
    perl -pi.bak -e "s@http://moth/w3af/@http://${hostname}@;s@output-w3af.txt@/home/w3af/w3af/scripts/output-w3af.txt@;" ~/w3af-shared/all.w3af
    echo 'exit' >> ~/w3af-shared/all.w3af
    echo y | docker run $DOCKER_ARGS -i --rm andresriancho/w3af /home/w3af/w3af/w3af_console --no-update -s scripts/all.w3af
    grep -i vulnerability  ~/w3af-shared/output-w3af.txt

fi
                '''
            }

/*
            stage("Run performance tests"){
            }

            stage("Create packer images"){
            }

            stage("Deploy"){
//                timeout(time:5, unit:'DAYS') {
//                    input message:'Approve deployment?', submitter: 'it-ops'
//                }
            }
*/
        }

    }

    catch(err) {
        currentBuild.result = "FAILURE"
        throw err
    }
}
