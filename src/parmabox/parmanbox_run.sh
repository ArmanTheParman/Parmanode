function parmabox_run {
if [[ $OS == "Mac" || $Linux="Mac" ]] ; then    
    docker run -du parman --privileged --hostname ParmaBox --name parmabox \
           -v $HOME/parmanode/parmabox:/home/parman/parmanode/parmabox \
           -e DISPLAY=$DISPLAY \
           -e XAUTHORITY=/home/parman/.Xauthority \
           -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
           -v /home/parman/.Xauthority:/home/parman/.Xauthority \
           -p 23:22 \
           -p 10999:10999 \
           -p 8399:8332 \
           -p 50051:50001 \
           parmabox \
           tail -f /dev/null

elif [[ $OS == "Linux" ]] ; then

    docker run -du parman --privileged --name parmabox \
           --network=host \
           -v $HOME/parmanode/parmabox:/home/parman/parmanode/parmabox \
           -e DISPLAY=$DISPLAY \
           -e XAUTHORITY=/home/parman/.Xauthority \
           -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
           -v /home/parman/.Xauthority:/home/parman/.Xauthority \
           parmabox \
           tail -f /dev/null

fi
}