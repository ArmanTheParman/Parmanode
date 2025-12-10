
function p4socket {

[[ $parmaview != 1 ]] && return 1

    count=0
    while [[ $count -lt 10 ]] ; do
    printf "%s\n" "$@" | socat - UNIX-SENDTO:$p4socketfile >$dn 2>&1 && return 0  #early exit of loop if success
    sleep 0.2
    let count++
    done
    printf "\n%s\nUnable to write to parmanode.sock...\n\n%s\n" "$(date)" "$@" 2>&1 | tee -a $pvlog >$dn 
    printf "%s\n" "$@" > $socketbacklog  2>$dn
    return 0
}

#per-item failure handling, and can be used in pipes
function p4socketlines { #for tailing

[[ $parmaview != 1 ]] && return 1

while IFS= read -r line; do
    printf "%s\n" "$line" | socat - UNIX-SENDTO:$p4socketfile >$dn 2>&1 && continue
    p4socket "$line"
done
}
