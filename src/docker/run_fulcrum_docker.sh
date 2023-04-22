function run_fulcrum_docker {

source $HOME/.parmanode/parmanode.conf

if [[ $drive_fulcrum == "external" ]] ; then

        docker_volume_mount="/Volumes/parmanode/fulcrum_db"

        while true ; do
        if $( ! mount | grep parmanode ) ; then
                log "fulcrum" "drive mount test failed. Offer to try again or exit."
                set_terminal ; echo "Please connect the drive, then hit <enter> to try again, (p) to return." ; read choice 
                if [[ $choice == "p" ]] ; then return 1 ; fi
                else 
                continue
                fi
        done

        fi

if [[ $drive_fulcrum == "internal" ]] ; then
    docker_volume_mount="$HOME/parmanode/fulcrum_db"
    fi

log "fulcrum" "Docker Volume Mount set at $docker_volume_mount"

docker stop fulcrum >/dev/null 2>&1 && log "fulcrum" "container stopped"
docker rm fulcrum >/dev/null 2>&1 && log "fulcrum" "container removed"
docker rmi fulcrum >/dev/null 2>&1 && log "fulcrum" "docker image deleted"

docker run -d --name fulcrum \
                -p 50002:50001 \
                -p 50001:50002 \
                -p 50003:50003 \
                -v ${docker_volume_mount}:/home/parman/parmanode/fulcrum_db \
                fulcrum \
&& log "fulcrum" "run command executed." && return 0

return 1 
}