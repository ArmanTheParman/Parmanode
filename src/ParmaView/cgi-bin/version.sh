#!/bin/bash
echo "Content-Type: text/plain"
echo ""


    function sendtosocket {
            while IFS= read -r line; do
                { [[ ${line: -1} == $'\n' ]] && printf "%s" "$line" ; } || printf "%s\n" "$line"
            done | socat - UNIX-CONNECT:"/run/parmanode/parmanode.sock"
    }

source "/opt/parmanode/version.conf"
#source "/opt/parmanode/src/ParmaView/sendtosocket.sh"

echo "$version" | sendtosocket 
echo "test"