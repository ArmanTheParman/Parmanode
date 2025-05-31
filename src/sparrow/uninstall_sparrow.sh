function uninstall_sparrow {
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall Sparrow 
$orange
    Are you sure? (y) (n)

########################################################################################
"
choose xpmq ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
n) return 1 ;; y) break ;;
esac
done

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
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
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
sudo rm -rf $hp/"*parrow-*" >$dn
installed_config_remove "sparrow"
success "Sparrow has been uninstalled"
}
