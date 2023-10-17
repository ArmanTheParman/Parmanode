function parmabox_exec {

# Install Parmanode in Parmabox, and ParmaShell
docker exec -it -u parman parmabox bash \
            -c "mkdir /home/parman/Desktop ; \
                curl https://parmanode.com/install.sh | sh ; \
                mkdir /home/parman/.parmanode ; \
                echo \"parmashell-end\" | tee /home/parman/.parmanode/installed.conf"

# Make bashrc better
docker exec -it -u root parmabox bash -c "echo \"#Added by Parmanode...\" | tee -a /root/.bashrc /home/parman/.bashrc"
docker exec -it -u root parmabox bash -c "echo \"function rp { cd $HOME/parman_programs/parmanode ; ./run_parmanode.sh $@ ; }\" | tee -a /root/.bashrc /home/parman/.bashrc"
docker exec -it -u root parmabox bash -c "echo \"source /home/parman/parman_programs/parmanode/src/ParmaShell/parmashell_functions\" | tee -a /root/.bashrc /home/parman/.bashrc"


}