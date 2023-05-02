function run_fulcrum_docker {

source $HOME/.parmanode/parmanode.conf >/dev/null 2>&1

if [[ $drive_fulcrum == "external" ]] ; then

        docker_volume_mount="/Volumes/parmanode/fulcrum_db"

        while true ; do
                if ! mount | grep parmanode >/dev/null 2>&1 ; then
                        log "fulcrum" "drive mount test failed. Offer to try again or exit."
                        set_terminal ; echo "Please connect the drive, then hit <enter> to try again, (p) to return." ; read choice 
                        if [[ $choice == "p" ]] ; then return 1 ; fi
                else 
                        break
                fi
        done

fi

if [[ $drive_fulcrum == "internal" ]] ; then
    docker_volume_mount="$HOME/parmanode/fulcrum_db"
    fi

log "fulcrum" "Docker Volume Mount set at $docker_volume_mount"


please_wait
docker run -d --name fulcrum \
                -p 50001:50001 \
                -p 50002:50002 \
                -p 50003:50003 \
                -v ${docker_volume_mount}:/home/parman/parmanode/fulcrum_db \
                -v $HOME/parmanode/fulcrum/config:/home/parman/parmanode/fulcrum/config \
                fulcrum >/$HOME/parmanode/fulcrum.log 2>&1 \
&& log "fulcrum" "run command executed."

sleep 3

make_fulcrum_symlinks_docker
move_fulcrum_config
return 0
}