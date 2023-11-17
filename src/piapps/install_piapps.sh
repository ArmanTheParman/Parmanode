function install_piapps {
if [[ $computer_type != Pi ]] ; then return 1 ; fi
clear
cd $hp
git clone --depth 1 https://github.com/Botspot/pi-apps
installed_conf_add "piapps-start"
cd pi-apps
./install
installed_conf_add "piassps-end"
success "PiApps" "being installed"
echo -e "
########################################################################################
$cyan
                                     PiAPPS
$orange
    Parmanode installed it for you, and can uninstall it should you choose, but there
    is not need to use Parmanode when interacting with PiApps.                                

    To do so, for exmample to install the Tor Browser on your Pi, and other cool 
    stuff, you can directly interact with PiApps from the Pi menus or PiApp desktop 
    icon.

########################################################################################
"
enter_continue
}