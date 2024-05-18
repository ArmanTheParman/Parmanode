function uninstall_rtl {
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall RTL 
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

please_wait

docker stop rtl
docker rm rtl 
docker rmi rtl 
sudo rm -rf $HOME/parmanode/rtl >/dev/null 2>&1
sudo rm ./src/rtl/RTL-Config.json >/dev/null 2>&1

sudo systemctl stop rtl.service
sudo systemctl disable rtl.service
sudo systemctl rm /etc/systemd/system/rtl.service

installed_config_remove "rtl"
#disable_tor_rtl
success "RTL" "being uninstalled."
return 0
}