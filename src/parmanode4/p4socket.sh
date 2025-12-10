
function p4socket {
    count=0
    while [[ $count -lt 10 ]] ; do
    printf "%s\n" "$@" | socat - UNIX-SENDTO:$p4socketfile && return 0
    sleep 0.2
    let count++
    done
    printf "\n%s\nUnable to write to parmanode.sock...\n\n%s\n" "$(date)" "$@" 2>&1 | tee -a $pvlog >$dn 
    printf "%s\n" "$@" > $socketbacklog 
    return 0
}

#per-item failure handling,
function p4socketlines { #for tailing
while IFS= read -r line; do
    printf "%s\n" "$line" | socat - UNIX-SENDTO:$p4socketfile && continue
    p4socket "$line"
done
}
