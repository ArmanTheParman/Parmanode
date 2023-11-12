function uninstall_torrelay {

set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall Tor Relay 
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

local file="/etc/tor/torrc"

sed -i '/#Tor Relay Installation.../,/#End Tor Relay Installation./d' $file
sudo apt-get purge nyx -y

install_config_remove "torrelay"
success "Your Tor Relay" "being uninstalled."
}