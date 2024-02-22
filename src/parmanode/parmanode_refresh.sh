
function parmanode_refresh {
while true ; do
if [[ $donotask != true ]] ; then
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
cd $HOME/parman_programs && rm -rf ./parmanode
git clone https://github.com/armantheparman/parmanode.git
pn
git config pull.rebase false >/dev/null 2>&1
success "The Parmanode script directory has been refreshed"
announce "Parmanode will quit now so the changes take effect."
exit 0
;;
*)
invalid
esac
done

}