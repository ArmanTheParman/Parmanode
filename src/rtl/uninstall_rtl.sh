function uninstall_rtl {

install_check "rtl" "uninstall" || { echo "Not installed. Skipping uninstall." ; enter_continue ; return 1 ; }

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
success "RTL" "being uninstalled."
return 0
}