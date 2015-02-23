#!/bin/sh

### Usage: ./masshot.sh 10.0.0.0/8
USAGE=$(grep "^###" "$0" | cut -c 5-)

check_command() {
    echo -n "Checking for ${1}..."
    if ! command -v ${1} > /dev/null; then
        echo "No ${1} in PATH."
        exit 127
    fi;
    echo
}

check_deps() {
    check_command masscan
    check_command phantomjs
    check_command parallel
    check_command sudo
}

pipe_resolve() {
    name=`dig -x ${1%:*} +short | sed 's/\.$//g'`;
    if [ $name ]; then
        echo "${name}:${1##*:}";
        echo "${1}";
    else
        echo ${1};
    fi;
}

masscancancan() {
    mscmd="sudo masscan ${MASSCANARGS} ${1}"
    for host in `${mscmd} | awk '{ gsub("/tcp", "", $4); print $6":"$4; }'`;
        do pipe_resolve ${host};
    done
}

main() {
    if [ -z "${1}" ]; then
        echo $USAGE
        exit 127
    else
        targets="${1}"
    fi;

    # Use MASSCANARGS if already set
    if [ -z $MASSCANARGS ]; then
        MASSCANARGS="-p80,443,8000,8080,8443"
    fi;

    check_deps
    masscancancan ${targets} | parallel ${PARALLELARGS} 'phantomjs shoot-page.js {}'
}

main $@
