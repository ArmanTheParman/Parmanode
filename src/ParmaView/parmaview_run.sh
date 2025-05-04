function parmaview_run {
if [[ $OS == "Mac" ]] ; then    
    docker run -du parman --hostname ParmaView --name parmaview \
           -v $HOME/parmanode/parmaview:/home/parman/parmanode/parmaview \
           -p 25:22 \
           -p 88:80 \
           -p 458:443 \
           -p 58000:58000 \ 
           -p 58001:58001 \ 
           -p 58002:58002 \ 
           -p 58003:58003 \ 
           -p 58004:58004 \ 
           parmaview \
           tail -f /dev/null

elif [[ $OS == "Linux" ]] ; then

    docker run -du parman --name parmaview \
           --network=host \
           -v $HOME/parmanode/parmaview:/home/parman/parmanode/parmaview \
           -v $pp/parmanode/:/home/parman/parman_programs/parmanode \
           parmaview \
           tail -f /dev/null

fi
}