function uninstall_mempool {
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall Mempool?
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



}