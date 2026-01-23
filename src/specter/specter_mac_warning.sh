function specter_mac_warning {
if [[ $OS == "Mac" ]] ; then
set_terminal ; echo -e " 
########################################################################################

    Warning for Mac users, Specter will only work for MacOS version 10.15 and later

$cyan
                    x)$orange                     Abort, abort!
$cyan
                    anything else) $orange        Continue

########################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
m|M) back2main ;; q|Q|QUIT|Quit|quit) exit 0 ;; p|P|x|X) return 1 ;; *) return 0 ;;
esac
else
return 0
fi
}
