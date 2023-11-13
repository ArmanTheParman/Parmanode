function docker_run_electrs {

if [[ $OS == Linux ]] ; then

docker run -d --name electrs \
                          --network="host" \
                          -v $HOME/parmanode/electrs/electrs_db:/home/parman/parmanode/electrs/electrs_db \
                          -v $HOME/.electrs:/home/parman/.electrs \
                          electrs 
fi 

if [[ $OS == Mac ]] ; then

docker run -d --name electrs \
                          -p 50005:50005 \
                          -p 50006:50006 \
                          -v $HOME/parmanode/electrs:/home/parman/parmanode/electrs \
                          -v $HOME/.electrs:/home/parman/.electrs \
                          electrs
fi

}