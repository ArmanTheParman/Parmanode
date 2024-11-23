function uninstall_parmabox {
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall ParmaBox 
$orange
    Are you sure? (y) (n)

########################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) backtomain ;;
y) break ;;
n) return 1 ;;
*) invalid ;;
esac
done
if ! docker ps >$dn ; then announce \
"Please make sure Docker is running before asking Parmanode to
    clean up the installed ParmaBox."
return 1
fi

docker stop parmabox 
docker rm parmabox 
docker rmi parmabox

yesorno "Do you want to delete this directory on your system as well?
$cyan     
        $HOME/parmanode/parmabox $orange" && sudo rm -rf $HOME/parmanode/parmabox >$dn

installed_config_remove "parmabox"
success "The Linux Docker ParmaBox" "being uninstalled"

}