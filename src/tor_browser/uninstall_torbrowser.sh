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

rm -rf $hp/tor-browser
rm $HOME/Desktop/start-tor-bro*

success "Tor Browser" "being uninstalled"
}