function uninstall_specter {
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall Specter 
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

while true ; do
set_terminal ; echo -e "
########################################################################################

                        REMOVE CONFIGURATION DIRECTORY TOO?
        
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
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
d)
sudo rm -rf $HOME/.specter
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
sudo rm -rf $HOME/parmanode/*pecter*
installed_config_remove "specter"
success "Specter" "being uninstalled."
fi

if [[ $OS == "Mac" ]] ; then
sudo rm -rf $HOME/parmanode/*pecter*
sudo rm -rf /Applications/*pecter*
installed_config_remove "specter"
success "Specter" "being uninstalled."
fi
}