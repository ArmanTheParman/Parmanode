function urgent_patch {

if curl -s https://raw.githubusercontent.com/ArmanTheParman/Parmanode/master/src/patches/urgent_patch_signal | grep -q "urgen_patch_signal=true" ; then
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
fi

return 0

}
#nohup curl -s https://raw.githubusercontent.com/ArmanTheParman/Parmanode/master/src/patches/urgent_patch_signal > $HOME/.parmanode/patch_status