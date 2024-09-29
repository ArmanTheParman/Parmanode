
function parmanode_refresh {
while true ; do
if [[ $donotask != "true" ]] ; then
set_terminal ; echo -e "
########################################################################################

    Sometimes, especially if you manually edit the code, updates to Parmanode
    might do strange things. You can get a fresh copy of the latest version of
    Parmanode without affecting any of the programs you installed or any configuration
    files - totally safe.
$green
                        rf)       Refresh Parmanode
$orange
                        a)        Abort

########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
else
choice=rf
fi

case $choice in
q|Q) exit 0 ;; p|P) return 0 ;; m|M) back2main ;;
a|A) return 1 ;;
rf)
cd $HOME
git clone https://github.com/armantheparman/parmanode.git parmanode_temp
file ./parmanode_temp/do_not_delete_move_rename.txt 1>/dev/null 2>&1 || { echo "Some problem with the download. Aborting. You might wnat to try again later." ; enter_continue ; return 1 ; }
sudo rm -rf $HOME/parman_programs/parmanode >/dev/null 2>&1
mv $HOME/parmanode_temp/ $HOME/parman_programs/parmanode >/dev/null 2>&1
cd $pn
git config pull.rebase false >/dev/null 2>&1
if ! git config user.email >/dev/null 2>&1 ; then git config user.email sample@parmanode.com ; fi
if ! git config user.name  >/dev/null 2>&1 ; then git config user.name ParmanodeUser ; fi
success "The Parmanode script directory has been refreshed"
announce "Parmanode will quit now so the changes take effect. Please restart again." ; clear
exit 0
;;
*)
invalid
esac
done

}