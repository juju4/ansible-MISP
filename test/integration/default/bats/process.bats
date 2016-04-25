#!/usr/bin/env bats

setup() {
    apt-get install -y curl >/dev/null || yum -y install curl >/dev/null; true
}

@test "MISP url should be accessible" {
    run curl -sSqL http://localhost/
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Users - MISP" ]]
}


