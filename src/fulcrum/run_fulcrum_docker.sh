function run_fulcrum_docker {

source $HOME/.parmanode/parmanode.conf >$dn 2>&1

if [[ $drive_fulcrum == "external" ]] ; then
        while true ; do
                if ! mount | grep parmanode >$dn 2>&1 ; then
                        log "fulcrum" "drive mount test failed. Offer to try again or exit."
                        set_terminal ; echo -e "Please connect the drive, then hit$cyan <enter>$orange to try again,$red p$orange to return." ; read choice 
                        if [[ $choice == "p" ]] ; then return 1 ; fi
                else 
                        break
                fi
        done
fi

please_wait

if [[ $OS == Mac ]] ; then
ports="-p 50001:50001 -p 50002:50002"
elif [[ $OS == Linux ]] ; then
ports="--network=host"
fi

docker run -d --name fulcrum \
                --restart unless-stopped \
                $ports \
                -v $HOME/.fulcrum_db:/home/parman/.fulcrum_db \
                -v $HOME/.fulcrum/:/home/parman/.fulcrum \
                fulcrum >$dn 2>&1 || return 1

sleep 3
return 0
}
