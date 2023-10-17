function parmabox_exec {

# Install Parmanode in Parmabox, and ParmaShell
docker exec -it -u parman parmabox bash \
            -c "mkdir /home/parman/Desktop ; \
                curl https://parmanode.com/install.sh | sh ; 
                mkdir /home/parman/.parmanode ;
                echo \"parmashell-end\" | tee /home/parman/.parmanode/installed.conf"

docker cp $HOME/parman_programs/parmanode/src/parmabox/bashrc_from_Mint.txt parmabox /tmp/

docker exec -it -u parman parmabox bash -c "cp /tmp/bashrc_from_Mint.txt /home/parman/.bashrc"


# Install ParmaShell for root user too
docker exec -it -u root parmabox bash -c "mv /tmp/bashrc_from_Mint.txt /root/.bashrc"

}