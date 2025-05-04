function uninstall_parmaview {
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall ParmaView
$orange
    Are you sure? (y) (n)

########################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
y) break ;;
n) return 1 ;;
*) invalid ;;
esac
done
if ! docker ps >$dn ; then announce \
"Please make sure Docker is running before asking Parmanode to
    clean up the installed ParmaView."
return 1
fi

docker stop parmaview 
docker rm parmaview 
docker rmi parmaview

yesorno "Do you want to delete this directory on your system as well?
$cyan     
        $HOME/parmanode/parmaview $orange" && sudo rm -rf $HOME/parmanode/parmaview >$dn

installed_config_remove "parmaview"
success "ParmaView" "being uninstalled"

}