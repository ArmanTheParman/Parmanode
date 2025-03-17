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
qrencode -t ANSIUTF8 "$(sudo cat ~/.ssh/id_rsa.pub)"
echo "onion address..."
qrencode -t ANSIUTF8 "$(sudo cat /var/lib/tor/parmanode-service/hostname | cut -d \. -f1)"
echo "Take a photo and send to Parman for ParMiner access. Or, copy text, next screen..."
enter_continue
clear
echo -e "Copy this text and send to Parman..\n$cyan"
sudo cat /var/lib/tor/parmanode-service/hostname | cut -d \. -f1
echo -e ""
sudo cat ~/.ssh/id_rsa.pub
echo  -e "$reset"

exit
fi

}