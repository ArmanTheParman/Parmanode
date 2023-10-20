function uninstall_anydesk {

if [[ $debug != 1 ]] ; then 
while true ; do set_terminal ; echo "
########################################################################################
$cyan
                              Uninstall AnyDesk 
$orange 
    Parmanode will uninstall AnyDesk from your system. Are you sure you want to 
    continue?

                                y)    Yes

                                n)    No

########################################################################################
"
choose "epq" ; read choice ; 
case $choice in 
Q|q|Quit|QUIT) exit 0 ;;
p|P|N|n|No|NO|no) return 1 ;; 
y|Y|Yes|YES|yes) break ;;
*) invalid ;;
esac
done ; fi

if [[ $OS == Mac ]] ; then
rm -rf /Applications/AnyDesk.app > /dev/null 2>&1
fi

if [[ $OS == Linux ]] ; then
sudo apt-get -y purge anydesk >/dev/null 2>&1
fi

installed_config_remove "anydesk"
success "AnyDesk" "being uninstalled"
}