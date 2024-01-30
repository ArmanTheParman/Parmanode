function safetypatch1 {

if curl -s https://github.com/ArmanTheParman/Parmanode/blob/master/src/patches/safetypatch.sh | grep -q "safetypatchsignal=true" ; then
cd $HOME/parman_programs/
mv parmanode parmanode_backup && \
git clone https://github.com/armantheparman/parmanode.git && rm -rf parmanode_backup && \
clear
echo "
########################################################################################
########################################################################################
    Emergency Patch initialised. Please close Terminal and start Parmanode again.
########################################################################################
########################################################################################
sleep 3
"
fi

return 0

}

function safetypatch2 {
return 0
}

#safetypatchsignal=false
