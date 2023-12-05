function uninstall_specter {
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall Specter 
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
    $HOME/.specter/
$orange

    This driectory includes your wallet files. 
    
    Note that if you have any non-Parmanode Specter installations, they share this same
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
rm -rf $HOME/.specter
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

if [[ $OS == "Linux" ]] ; then
rm -rf $HOME/parmanode/*pecter*
installed_config_remove "specter"
success "Specter" "being uninstalled."
fi

if [[ $OS == "Mac" ]] ; then
rm -rf $HOME/parmanode/*pecter*
rm -rf /Applications/*pecter*
installed_config_remove "specter"
success "Specter" "being uninstalled."
fi
}