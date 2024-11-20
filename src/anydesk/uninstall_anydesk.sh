function uninstall_anydesk {
while true ; do set_terminal ; echo -e "
########################################################################################
$cyan
                               Uninstall AnyDesk 
$orange 
    Parmanode will uninstall AnyDesk from your system. Are you sure you want to 
    continue?
$cyan
                                y)$orange    Yes
$cyan
                                n)$orange    No

########################################################################################
"
choose "epq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in 
Q|q|Quit|QUIT) exit 0 ;; p|P|N|n|No|NO|no) return 1 ;; y|Y|Yes|YES|yes) break ;;
*) invalid ;;
esac
done 

if [[ $OS == Mac ]] ; then
sudo rm -rf /Applications/AnyDesk.app > /dev/null 2>&1
fi

if [[ $OS == Linux ]] ; then
sudo apt-get -y purge anydesk >/dev/null 2>&1
fi

installed_config_remove "anydesk"
success "AnyDesk" "being uninstalled"
}