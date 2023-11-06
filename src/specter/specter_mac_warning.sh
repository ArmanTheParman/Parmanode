function specter_mac_warning {
if [[ $OS == "Mac" ]] ; then
set_terminal ; echo " 
########################################################################################

    Warning for Mac users, Specter will only work for MacOS version 10.15 and later


                    x)                     Abort, abort!

                    anything else)         Continue

########################################################################################
"
choose "xpmq"
read choice
case $choice in
    m) back2main ;;
    q|Q|QUIT|Quit|quit) exit 0 ;;
    p|P|x|X) return 1 ;;
    *) return 0 ;;
esac
fi
}
