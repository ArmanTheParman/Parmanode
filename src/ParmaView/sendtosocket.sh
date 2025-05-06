function sendtosocket {
        while IFS= read -r line; do
            { [[ ${line: -1} == $'\n' ]] && printf "%s" "$line" ; } || printf "%s\n" "$line"
        done | socat - UNIX-CONNECT:"/run/parmanode/parmanode.sock"
}
