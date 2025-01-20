
function parmanode_refresh {
set_terminal
echo -e "${green}Refreshing $pn directory from GitHub..."
sleep 1

cd $HOME
git clone https://github.com/armantheparman/parmanode.git parmanode_temp
[ -f ./parmanode_temp/version.conf ] || { echo "Some problem with the download. Aborting. You might wnat to try again later." ; enter_continue ; return 1 ; }
sudo rm -rf $HOME/parman_programs/parmanode >$dn 2>&1
mv $HOME/parmanode_temp $HOME/parman_programs/parmanode >$dn 2>&1
cd $pn
git config pull.rebase false >$dn 2>&1
if ! git config user.email >$dn 2>&1 ; then git config user.email sample@parmanode.com ; fi
if ! git config user.name  >$dn 2>&1 ; then git config user.name ParmanodeUser ; fi
success "The Parmanode script directory has been refreshed"
announce "Parmanode will quit now so the changes take effect. Please restart again." ; clear
exit 0

}