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

if [[ $1 == "parminerkey" ]] ; then
if yesorno_blue "This will print for you the authentication key to pass on to Parman.
    
    You have choices..." "qr" "Print QR Code" "text" "Just text on the screen" ; then
sudo true
clear
which qrencode || install_qrencode silent
set_terminal 77 150
echo -e "${cyan}ID...\n"
qrencode -t ANSIUTF8 "$(sudo cat $macprefix/var/lib/tor/parmanode-service/hostname | cut -d \. -f1)"
echo -e "\n${cyan}Key...\n"
qrencode -t ANSIUTF8 "$(sudo cat ~/.ssh/extra_keys/parminer-key.pub)"
echo -e "$green\nTake a photo and send to Parman for ParMiner access.$orange"
enter_continue
else
sudo true
clear
echo -e "${cyan}ID...\n"
sudo cat $macprefix/var/lib/tor/parmanode-service/hostname | cut -d \. -f1
echo -e "\n{$cyan}Key...\n"
sudo cat ~/.ssh/extra_keys/parminer-key.pub
echo -e "$green\nTake a photo and send to Parman for ParMiner access.$orange"
enter_continue
fi

exit
fi

if [[ $install == cgi ]] ; then
install_cgi 
fi

if [[ $uninstall == cgi ]] ; then
uninstall_cgi
fi
}