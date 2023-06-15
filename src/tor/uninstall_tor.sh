function uninstall_tor {

set_terminal ; echo "
########################################################################################

                                 Uninstall Tor
 
    Parmanode will uninstall Tor from your system. Hit <enter> to proceed.

########################################################################################
"
choose "epq" ; read
case $choice in Q|q|Quit|QUIT) exit 0 ;; p|P) return 1 ;; esac

sudo systemctl stop tor
sudo apt-get purge tor -y
sudo rm -rf /etc/tor /var/lib/tor >/dev/null 2>&1
installed_config_remove "tor"
enter_continue
return 0
}
