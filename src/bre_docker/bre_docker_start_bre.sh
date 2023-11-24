#this funny function name is to distinguish between bre_docker_start, which
#starts the container, but this function start BRE inside an already
#started container.
function bre_docker_start_bre {
counter=0
while [[ $counter -lt 4 ]] ; do
if docker ps >/dev/null 2>&1 ; then

    if docker ps 2>/dev/null | grep -q bre ; then
    debug "before exec"
        docker exec -d -u root bre /bin/bash -c "btc-rpc-explorer" 
    debug "after exec"
    fi
    return 0

else
   if [[ $OS == Mac ]] ; then start_docker_mac ; fi
   counter=$((counter + 1))
   continue
fi
done

announce "Docker isn't running. Aborting." 
return 1
}