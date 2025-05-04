function parmanode_in_parmaview {
# Install ParmaShell in ParmaView
docker exec -it -u parman parmaview bash -c "echo \"parmashell-end\" | tee -a /home/parman/.parmanode/installed.conf >$dn"

# Make bashrc better
docker exec -it -u root parmaview bash -c "echo \"function rp { cd /home/parman/parman_programs/parmanode ; ./run_parmanode.sh \$@ ; }\" | tee -a /root/.bashrc /home/parman/.bashrc" >$dn 2>&1
docker exec -it -u root parmaview bash -c "echo \"source /home/parman/parman_programs/parmanode/src/ParmaShell/parmashell_functions\" | tee -a /root/.bashrc /home/parman/.bashrc" >$dn 2>&1
docker exec -it -u root parmaview bash -c "sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/' /root/.bashrc " >$dn 2>&1
docker exec -it -u root parmaview bash -c "sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/' /home/parman/.bashrc" >$dn 2>&1
docker exec -it -u root parmaview bash -c "chown -R parman:parman /home/parman"
unset parmaview
}