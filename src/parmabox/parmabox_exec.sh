function parmabox_exec {

# Install Parmanode in Parmabox, and ParmaShell
docker exec -it -u parman parmabox bash \
            -c "mkdir /home/parman/Desktop ; \
                echo \"source /home/parman/parman_programs/parmanode/src/ParmaShell/parmashell_functions\" | tee /home/parman/.bashrc ; \
                curl https://parmanode.com/install.sh | sh ; 
                mkdir /home/parman/.parmanode ;
                echo \"parmashell-end\" | tee /home/parman/.parmanode/installed.conf"

# Install ParmaShell for root user too
docker exec -it -u root parmabox bash \
            -c "echo \"source /home/parman/parman_programs/parmanode/src/ParmaShell/parmashell_functions\" | tee /root/.bashrc"

}