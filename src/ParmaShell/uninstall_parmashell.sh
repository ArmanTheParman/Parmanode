function uninstall_parmashell {
if [[ $1 != silent ]] ; then
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall ParmaShell 
$orange
    Are you sure? (y) (n)

########################################################################################
"
choose xpmq ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
n) return 1 ;; y) break ;;
rem)
rem="true"
break
;;
esac
done

sudo gsed -i '/Added by Parmanode below/,/Added by Parmanode above/d' "$bashrc"
sudo gsed -i '/ParmaShell/d' "$bashrc"

installed_config_remove "parmashell"
if [[ $1 != silent ]] ; then
success "ParmaShell" "being uninstalled."
fi
}

