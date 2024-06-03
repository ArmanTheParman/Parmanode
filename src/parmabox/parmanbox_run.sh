function parmabox_run {
    
    docker run -d --privileged --hostname ParmaBox --name parmabox \
           -v $HOME/parmanode/parmabox:/home/parman/parmanode/parmabox \
           -p 10999:10999 \
           -p 8399:8332 \
           -p 50051:50001 \
           parmabox \
           tail -f /dev/null

}