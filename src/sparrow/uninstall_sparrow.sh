function uninstall_sparrow {
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall Sparrow 
$orange
    Are you sure? (y) (n)

########################################################################################
"
choose "x" 
read choice
set_terminal

if [[ $choice == "y" || $choice == "Y" ]] ; then true
    else 
    return 1
    fi

while true ; do
set_terminal ; echo -e "
########################################################################################

                        REMOVE CONFIGURATION DIRECTORY TOO?
        
$cyan
    $HOME/.sparrow/
$orange

    This directory includes your wallet files. 
    
    Note that if you have any non-Parmanode Sparrow installations, they share this same
    directory.
$red

                                d)       Delete
$green
                                l)       Leave it
$orange
########################################################################################
"
choose "x"
read choice
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
d)
sudo rm -rf $HOME/.sparrow
break
;;
l)
break
;;
*)
invalid
;;
esac
done

sudo rm -rf $HOME/parmanode/*parrow* #redundant, folder doesn't exist yet, but will later.

if [[ $OS == "Mac" ]] ; then
sudo rm -rf /Applications/Sparrow.app
fi

#clean up downloads
sudo rm -rf $hp/"*parrow-1."*
sudo rm $dp/.sparrow_first_run >/dev/null 2>&1
installed_config_remove "sparrow"
success "Sparrow" "being uninstalled."
}
