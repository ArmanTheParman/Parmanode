function uninstall_rtl {

install_check "rtl" "uninstall" || { echo "Not installed. Skipping uninstall." ; enter_continue ; return 1 ; }

please_wait

docker stop rtl 2>/dev/null
docker rmi rtl 2>/dev/null
rm -rf $HOME/parmanode/rtl
rm ./src/rtl/RTL-Config.json >/dev/null 2&>1

installed_config_remove "rtl"
success "rtl" "being uninstalled."
return 0
}