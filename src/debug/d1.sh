function d1 {

export success=silent
cd $pp/parmaview && git pull
uninstall_parmaview
install_parmaview

}