function run_fulcrum_docker {

source $HOME/.parmanode/parmanode.conf >/dev/null 2>&1

if [[ $drive_fulcrum == "external" ]] ; then

        docker_volume_mount="$pd/fulcrum_db"

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
    docker_volume_mount="$HOME/.fulcrum_db"
    fi

please_wait
docker run -d --name fulcrum \
                -v ${docker_volume_mount}:/home/parman/parmanode/fulcrum_db \
                --restart unless-stopped \
                -p 50001:50001 \
                -p 50002:50002 \
                -v $HOME/.fulcrum_db:/home/parman/fulcrum_db
                -v $HOME/.fulcrum/:/home/parman/.fulcrum \
                -v $HOME/parmanode/fulcrum/config:/home/parman/parmanode/fulcrum/config \
                fulcrum >/$HOME/parmanode/fulcrum.log 2>&1 || return 1

sleep 3

return 0
}
