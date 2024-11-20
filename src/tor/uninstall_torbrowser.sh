function uninstall_torbrowser {
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall Tor Browser
$orange
    Are you sure? (y) (n)

########################################################################################
"
choose xpmq ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
n) return 1 ;; y) break ;;
rem)
rem="true"
break
;;
esac
done

if [[ $computer_type == LinuxPC ]] ; then
sudo rm -rf $hp/tor-browser
sudo rm $HOME/.local/share/applications/start-tor*
fi

if [[ $OS == Mac ]] ; then
sudo rm -rf /Applications/Tor*app
fi

installed_conf_remove "torb"
success "Tor Browser" "being uninstalled"
}