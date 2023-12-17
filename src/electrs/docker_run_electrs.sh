function docker_run_electrs {
source $pc >/dev/null 2>&1

if [[ $OS == Linux ]] ; then

    if [[ $drive_electrs == internal ]] ; then
    docker run -d --name electrs \
                            --network="host" \
                            -v $HOME/parmanode/electrs/electrs_db:/home/parman/parmanode/electrs/electrs_db \
                            -v $HOME/.electrs:/home/parman/.electrs \
                            electrs 
    fi 


    if [[ $drive_electrs == external ]] ; then
    docker run -d --name electrs \
                            --network="host" \
                            -v $parmanode_drive/electrs_db:/electrs_db \
                            -v $HOME/.electrs:/home/parman/.electrs \
                            electrs 
    fi

fi #end if Linux


if [[ $OS == Mac ]] ; then

docker run -d --name electrs \
                          -p 50005:50005 \
                          -p 50006:50006 \
                          -v $HOME/parmanode/electrs:/home/parman/parmanode/electrs \
                          -v $HOME/.electrs:/home/parman/.electrs \
                          electrs
fi

}