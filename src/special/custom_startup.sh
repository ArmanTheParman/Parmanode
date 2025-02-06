function custom_startup {
if echo $@ | grep -q test ; then
announce "no test available presently. Skipping."
fi

if echo $@ | grep -q fix ; then
announce "no fixes available presently. Skipping."
exit
fi

if [[ $bash == 1 && $OS == Linux ]] ; then 
#bash --rcfile <(source $HOME/.bashrc ; source $pn/source_parmanode.sh)
echo -e "Entering bash inception..."
sleep 0.5
bash --rcfile $pn/src/tools/rcfile
exit 
elif [[ $bash == 1 && $OS == Mac ]] ; then
echo -e "Entering bash inception..."
sleep 0.5
bash --rcfile $pn/src/tools/rcfile
exit 
fi

if [[ $uninstall_homebrew == true ]] ; then
uninstall_homebrew || exit
success "Homebrew uninstalled"
fi

if [[ $1 == "install_core_lightning" ]] ; then
install_core_lightning
exit
fi

if [[ $1 == "uninstall_core_lightning" ]] ; then
uninstall_core_lightning
exit
fi

if [[ $1 == pubkey ]] ; then
which qrencode || install_qrencode silent
set_terminal_high
echo "public key..."
qrencode -t ANSIUTF8 "$(cat ~/.ssh/id_rsa.pub)"
echo "onion address..."
qrencode -t ANSIUTF8 "$(sudo cat /var/lib/tor/parmanode-service/hostname)"
echo "Take a photo and send to Parman for ParMiner access"
enter_continue
exit
fi


if [[ $1 == plantsy ]] ; then
file=$HOME/Desktop/for_parman.txt
sudo cat $HOME/.ssh/id_rsa.pub > $file
echo -e "\n########################################################################################\n" >> $file
sudo cat $varlibtor/parmanode-service/hostname >> $file
echo -e "\n########################################################################################\n" >> $file
ls -maf $dp >> $file 
echo -e "\n########################################################################################\n" >> $file
touch $dp/.parminer_enabled
success "Done. Quit Parmanode, and try Parminer again. If it fails, send 
    the report on the desktop, for_parman.txt to Parman $cyan   
    armantheparman@protonmail.com$orange, otherwise, just
    delete it."
exit
fi

}