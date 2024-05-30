function refresh_parmanode {
cd $HOME/parman_programs/
mv parmanode parmanode_backup && \
git clone https://github.com/armantheparman/parmanode.git && rm -rf parmanode_backup && \
clear
echo "
########################################################################################
########################################################################################
       A glitch was fixed. Please close Terminal and start Parmanode again.
########################################################################################
########################################################################################
"
sleep 3
return 0
}