function parmabox_run {
    
    docker run -d --privileged --hostname ParmaBox --name parmabox \
           -v $HOME/parmanode/parmabox:/home/parman/parmanode/parmabox \
           -p 10000:10000 \
           -p 8399:8332 \
           -p 50051:50001 \
           -p 11111:11111 \
           parmabox \
           tail -f /dev/null

}