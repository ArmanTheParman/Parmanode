function podman_run_electrs {
source $pc >$dn 2>&1

if [[ $OS == Linux ]] ; then

    if [[ $drive_electrs == internal ]] ; then
    podman run -d --name electrs \
                            --network="host" \
                            --restart unless-stopped \
                            -v $HOME/.electrs_db:/electrs_db \
                            -v $HOME/.electrs:/home/parman/.electrs \
                            electrs 
    fi 


    if [[ $drive_electrs == external ]] ; then
    podman run -d --name electrs \
                            --network="host" \
                            --restart unless-stopped \
                            -v $pd/electrs_db:/electrs_db \
                            -v $HOME/.electrs:/home/parman/.electrs \
                            electrs 
    fi

fi #end if Linux


if [[ $OS == Mac ]] ; then
    if [[ $drive_electrs == internal ]] ; then 
        podman run -d --name electrs \
                                -p 50005:50005 \
                                --restart unless-stopped \
                                -p 50006:50006 \
                                -p 9060:9060 \
                                -v $HOME/.electrs_db:/electrs_db \
                                -v $HOME/.electrs:/home/parman/.electrs \
                                electrs
    fi

    if [[ $drive_electrs == external ]] ; then 
        podman run -d --name electrs \
                                -p 50005:50005 \
                                 --restart unless-stopped \
                                -p 50006:50006 \
                                -p 9060:9060 \
                                -v $pd/electrs_db:/electrs_db \
                                -v $HOME/.electrs:/home/parman/.electrs \
                                electrs
    fi                            
fi

}