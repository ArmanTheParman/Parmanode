function menu_add_extras {
while true
menu_add_source
do
set_terminal
echo -e "
########################################################################################
#                                                                                      #
#    P A R M A N O D E --> Main Menu --> Install Menu  -->$cyan Extras        $orange              #
#                                                                                      #
########################################################################################
#                                                                                      #
#                                                                                      #
#              (rr)      RAID - join drives together                                   #
#                                                                                      #
#              (h)       HTOP - check system resources                                 #
#                                                                                      #
#              (u)       Add UDEV rules for HWWs (only needed for Linux)               #
#                                                                                      #
#              (fb)      Parman's recommended free books (pdfs)                        #
#                                                                                      #
#                                                                                      #
########################################################################################
"
choose "xpmq"

read choice

case $choice in

m|M) back2main ;;

rr)
    install_raid 
    return 0
;; 

h|H|htop|HTOP|Htop)

    if [[ $OS == "Mac" ]] ; then htop ; break ; return 0 ; fi
    if ! which htop ; then sudo apt-get install htop -y >/dev/null 2>&1 ; fi
    announce "To exit htop, hit$cyan q$orange"
    htop
;;

u|U|udev|UDEV)

    if grep -q udev-end < $dp/installed.conf ; then
    announce "udev already installed."
    return 0
    fi
    udev
;;
fb|FB)
get_books
;;

q|Q|quit|QUIT)
    exit 0
    ;;
p|P)
    menu_add_new
    ;;
*)
    invalid
    continue
    ;;
esac
done

return 0

}

