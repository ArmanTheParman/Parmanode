function uninstall_torbrowser {
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall Tor Browser
$orange
    Are you sure? (y) (n)

########################################################################################
"
choose "x" 
read choice
set_terminal

if [[ $choice == "y" || $choice == "Y" ]] ; then true
    else 
    return 1
    fi

if [[ $computer_type == LinuxPC ]] ; then
rm -rf $hp/tor-browser
rm $HOME/.local/share/applications/start-tor*
fi

if [[ $OS == Mac ]] ; then
sudo rm -rf /Applications/Tor*app
fi

installed_conf_remove "torb"
success "Tor Browser" "being uninstalled"
}