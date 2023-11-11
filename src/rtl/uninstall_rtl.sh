function uninstall_rtl {
set_terminal ; echo "
########################################################################################

                                 Uninstall RTL 

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

please_wait

docker stop rtl 2>/dev/null
docker rm rtl 2>/dev/null
docker rmi rtl 2>/dev/null
sudo rm -rf $HOME/parmanode/rtl >/dev/null 2>&1
sudo rm ./src/rtl/RTL-Config.json >/dev/null 2>&1

sudo systemctl stop rtl.service
sudo systemctl disable rtl.service
sudo systemctl rm /etc/systemd/system/rtl.service

installed_config_remove "rtl"
disable_tor_rtl
success "RTL" "being uninstalled."
return 0
}