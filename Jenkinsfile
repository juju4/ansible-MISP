// Work in progress

node {

    try{
        currentBuild.result = "SUCCESS"
        def workspace = pwd()
        //def git_url = build.getEnvironment(listener).get('GIT_URL')
        //def directory = git_url.substring(input.lastIndexOf("/") + 1)
        def directory = "juju4.MISP"

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

//                sh "kitchen test ${defaultplatform}"
                // must keep instance for security testing after
                sh "kitchen verify ${defaultplatform}"
            }

/*
            stage("Build and verify all platforms"){
                sh "kitchen test"
/// OR
/// Work in progress, parallel build and not previously tested nodes

// org.codehaus.groovy.control.MultipleCompilationErrorsException: startup failed:
// WorkflowScript: 59: unable to resolve class string
// @ line 59, column 63.
//   platforms.split("\n").collect{it as stri

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
*/

            stage("Run security tests"){
                defaultplatform = sh (
                    script: '''#!/bin/bash
kitchen list | awk "!/Instance/ {print \\$1; exit}"
                        ''',
                    returnStdout: true
                    ).trim()
                echo "default platform: ${defaultplatform}"

                out1 = sh (
                    script: '''#!/bin/bash -x
defaultplatform=`kitchen list | awk '!/Instance/ {print $1; exit}'`
## read ssh config from json .kitchen/{platform}.yml
f=.kitchen/${defaultplatform}.yml
if [ -f $f ]; then

    reportsdir=$(pwd)/reports
    [ ! -d ${reportsdir} ] && mkdir ${reportsdir}
    awk -F'[: ]' '/(hostname|username|ssh_key)/ { OFS=""; print $1,"=",$3 }' ${f} > /tmp/sshvars.${BUILD_TAG}
    . /tmp/sshvars.${BUILD_TAG}
    SSH_ARGS="-t ssh://${username}@${hostname}"
    [ -z "${ssh_key}" ] && ssh_key=$HOME/.ssh/id_rsa
    SSH_ARGS="$SSH_ARGS -i ${ssh_key/$HOME/\\/share}"
    DOCKER_ARGS="-v $HOME/.ssh:/share/.ssh:ro --read-only --tmpfs /run --tmpfs /tmp --tmpfs /root/.inspec"
    targeturl="http://${hostname}"
    echo "targeturl=\"http://${hostname}\"" >> /tmp/sshvars.${BUILD_TAG}

    docker info

    echo "Check: Inspec"
## +user+readonly+tmpfs?
    docker pull chef/inspec | cat
    docker run $DOCKER_ARGS -it --rm chef/inspec exec https://github.com/dev-sec/tests-ssh-hardening $SSH_ARGS
    docker run $DOCKER_ARGS -it --rm chef/inspec exec https://github.com/juju4/tests-os-hardening $SSH_ARGS
    docker run $DOCKER_ARGS -it --rm chef/inspec exec https://github.com/dev-sec/tests-apache-hardening $SSH_ARGS
    docker run $DOCKER_ARGS -it --rm chef/inspec exec https://github.com/dev-sec/tests-mysql-hardening

else
    echo "Missing kitchen configuration file $f (current path "`pwd`")"
fi
                    ''',
                    returnStdout: true
                )

                out2 = sh (
                    script: '''#!/bin/bash -x

    . /tmp/sshvars.${BUILD_TAG}
    echo "Check: Nmap"
    DOCKER_ARGS="--read-only --tmpfs /run --tmpfs /tmp v ${reportsdir}:/home/nmap/reports"
    docker pull uzyexe/nmap | cat
    docker run --rm uzyexe/nmap -oA /home/nmap/reports/nmap -A ${hostname}
                    ''',
                    returnStdout: true
                )

                out3 = sh (
                    script: '''#!/bin/bash -x

    . /tmp/sshvars.${BUILD_TAG}
    echo "Check: W3af"
## https://github.com/andresriancho/w3af/commit/305e1670c9403d5f8265f11cc4c0813f768dc811
## Error while reading plugin options: "Invalid file option "~/output-w3af.csv"
    #DOCKER_ARGS="--read-only --tmpfs /run --tmpfs /tmp --tmpfs /home/w3af/.w3af -v $HOME/w3af-shared:/home/w3af/w3af/scripts:ro"
    DOCKER_ARGS="--tmpfs /run --tmpfs /tmp --tmpfs /home/w3af/.w3af -v ${reportsdir}:/home/w3af/w3af/scripts:rw"
    docker pull andresriancho/w3af | cat
    wget -q -O ${reportsdir}/all.w3af https://github.com/andresriancho/w3af/raw/master/scripts/all.w3af
    perl -pi.bak -e "s@http://moth/w3af/@${targeturl}@;s@output-w3af.txt@/home/w3af/w3af/scripts/output-w3af.txt@;" ${reportsdir}/all.w3af
    echo 'exit' >> ${reportsdir}/all.w3af
    echo y | docker run $DOCKER_ARGS -i --rm andresriancho/w3af /home/w3af/w3af/w3af_console --no-update -s scripts/all.w3af
    grep -i vulnerability  ~/w3af-shared/output-w3af.txt
                    ''',
                    returnStdout: true
                )

                out4 = sh (
                    script: '''#!/bin/bash -x

    . /tmp/sshvars.${BUILD_TAG}
    echo "Check: W3af"
    echo "Check: Arachni"
    DOCKER_ARGS="--tmpfs /run --tmpfs /tmp -v $(pwd)/reports:/home/arachni/reports:rw"
    docker pull arachni/arachni | cat
    docker run $DOCKER_ARGS --rm arachni/arachni --checks=*,-emails --scope-include-subdomains --timeout 00:05:00 --report-save-path=/home/arachni/reports/report-arachni ${targeturl}
    docker run $DOCKER_ARGS --rm arachni/arachni_reporter /home/arachni/reports/report-arachni --reporter=html:outfile=/home/arachni/reports/report-arachni.html
                    ''',
                    returnStdout: true
                )

                out5 = sh (
                    script: '''#!/bin/bash -x

    . /tmp/sshvars.${BUILD_TAG}
    echo "Check: ZAP"
## https://github.com/zaproxy/zaproxy/wiki/ZAP-Baseline-Scan
## https://blog.mozilla.org/webqa/2016/05/11/docker-owasp-zap-part-one/
## https://blog.mozilla.org/security/2017/01/25/setting-a-baseline-for-web-security-controls/
    DOCKER_ARGS="--tmpfs /run --tmpfs /tmp -v $(pwd)/reports:/zak/wrk/:rw"
    docker pull owasp/zap2docker-stable | cat
    docker run $DOCKER_ARGS -i owasp/zap2docker-stable zap-cli quick-scan --self-contained --start-options '-config api.disablekey=true' ${targeturl}
## passive scan
    docker run $DOCKER_ARGS -t owasp/zap2docker-stable zap-baseline.py -t ${targeturl} -r testreport.html
#    docker run $DOCKER_ARGS -i owasp/zap2docker-stable zapr --debug --summary ${targeturl}

## ?http://126kr.com/article/16y567o86y, https://github.com/DanMcInerney/xsscrapy
### BDD security? Gauntlt? Mozilla Minion?

                    ''',
                    returnStdout: true
                )
                echo "security test output:\n${out}"
            }
/*
            stage("Run security tests - BDD-security"){
                defaultplatform = sh (
                    script: '''#!/bin/bash
kitchen list | awk "!/Instance/ {print \\$1; exit}"
                        ''',
                    returnStdout: true
                    ).trim()
                echo "default platform: ${defaultplatform}"

// https://github.com/continuumsecurity/bdd-security/wiki/2-Getting-Started
// https://github.com/continuumsecurity/bdd-security/wiki/3-Configuration
// Archive build/reports
                out = sh (
                    script: '''#!/bin/bash
#apt-get -y install gradle
git clone https://github.com/continuumsecurity/bdd-security.git
cd bdd-security
perl -pi.bak -e "s@http://localhost:8080/@${targeturl}@; config.xml
./gradlew -Dcucumber.options="--tags @authentication --tags ~@skip"
                    ''',
                    returnStdout: true
                )
                echo "security test output:\n${out}"
            }
*/
/*
            stage("Run performance tests"){
            }
*/

/*
            stage("Test packer images creation"){
// packer lxc: can be done inside kitchen
// packer vmware, virtualbox - NOK digitalocean droplet, ?OK 32bits only google cloud
                dir("$directory/packer") {
                    sh "packer build -only=virtualbox-iso packer-*.json"
                }

            }
*/

/*
            stage("Deploy"){
//                timeout(time:5, unit:'DAYS') {
//                    input message:'Approve deployment?', submitter: 'it-ops'
//                }
            }
*/

            stage("Cleanup if no errors"){
                sh "kitchen destroy"
            }

        }

    }

    catch(err) {
        currentBuild.result = "FAILURE"
        throw err
    }
}
