
function parmanode_refresh {
while true ; do
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
case $choice in
q|Q) exit 0 ;; p|P) return 0 ;; m|M) back2main ;;
a|A) return 1 ;;
rf)
cd $HOME/parman_programs && rm -rf ./parmanode
git clone https://github.com/armantheparman/parmanode.git
success "The Parmanode script directory has been refreshed"
announce "Please quit and restart Parmanode to see changes take effect."
;;
*)
invalid
esac
done

}