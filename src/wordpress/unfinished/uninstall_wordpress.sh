function uninstall_wordpress {

set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall Wordpress?
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

    Delete any existing phpmyadmin directory?
   $green
    y) yes
$red
    n) no
$orange
########################################################################################
"
choose "xpmq" ; read choice
case $choice in
q|Q) exit 0 ;; p|P|M|m) back2main ;;
y)
rm -rf $hp/phpmyadmin ; break
;;
n)
break
;;
*)
invalid
;;
esac
done
    
}