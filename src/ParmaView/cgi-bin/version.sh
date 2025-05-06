#!/bin/bash
echo "Content-Type: text/plain"
echo ""

#source "/opt/parmanode/src/ParmaView/sendtosocket.sh"
function sendtosocket {
        while IFS= read -r line; do
            { [[ ${line: -1} == $'\n' ]] && printf "%s" "$line" ; } || printf "%s\n" "$line"
        done | socat - UNIX-CONNECT:"/run/parmanode/parmanode.sock"
}

source "/opt/parmanode/version.conf"


echo "$version" | sendtosocket 
echo "$version test"
