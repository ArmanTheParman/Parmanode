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

                        REMOVE CONFIGURATION DIRECORY TOO?
        
$cyan
    $HOME/.sparrow/
$orange

    This driectory includes you wallet files. 
    
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
rm -rf $HOME/.sparrow
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

rm -rf $HOME/parmanode/*parrow* #redundant, folder doesn't exist yet, but will later.

if [[ $OS == "Mac" ]] ; then
sudo rm -rf /Applications/Sparrow.app
fi

#clean up downloads
rm -rf $hp/"*parrow-1."*
rm $dp/.sparrow_first_run >/dev/null 2>&1
installed_config_remove "sparrow"
success "Sparrow" "being uninstalled."
}
