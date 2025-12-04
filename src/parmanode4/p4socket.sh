
function p4socket {
    count=0
    while [[ $count -lt 10 ]] ; do
    printf "%s\n" "$@" | socat - UNIX-DGRAM:/usr/local/bin/parmanode/parmanode.sock && return 0
    sleep 0.2
    let count++
    done
}


function p4socketlines { #for tailing
while IFS= read -r line; do
    printf "%s\n" "$line" | socat - UNIX-DGRAM:/usr/local/bin/parmanode/parmanode.sock
done
}

function p4signal {
    {
    printf "###ParmaViewSigStart###\n"
    # delimeter is \0 (null), so new lines are captured in the variable.
    # loop is actually redundant because of this, but leaving it in case I change the delimeter later.
    while IFS= read -r -d '' data ; do 
        printf "%s" "$data"
    done
    printf "###ParmaViewSigEnd###\n"
    } > $parmanode_unix_socket
}
