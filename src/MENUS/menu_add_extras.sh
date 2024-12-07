function menu_add_extras {
while true ; do
menu_add_source
if [[ $hp/parman_books ]] ; then UPDATE="${green}UPDATE "; delete="\b\b\b\b\b\b" ; else unset UPDATE delete ; fi
set_terminal
echo -en "
########################################################################################
#                                                                                      #
#    P A R M A N O D E --> Main Menu --> Install Menu  -->$cyan Extras        $orange              #
#                                                                                      #
########################################################################################
#                                                                                      #
#                                                                                      #
#$cyan              (rr)$orange      RAID - join drives together                                   #
#                                                                                      #
#$cyan              (h)$orange       HTOP - check system resources                                 #
#                                                                                      #
#$cyan              (u)$orange       Add UDEV rules for HWWs (only needed for Linux)               #
#                                                                                      #
#$cyan              (fb)$orange      ${UPDATE}Parman's recommended free books (pdfs)$orange $delete                       #
#                                                                                      #
#                                                                                      #
########################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 0 ;; m|M) back2main ;;

rr)
    install_raid 
    return 0
;; 

h|H|htop|HTOP|Htop)

    if [[ $OS == "Mac" ]] ; then htop ; break ; return 0 ; fi
    if ! which htop ; then sudo apt-get install htop -y >$dn 2>&1 ; fi
    announce "To exit htop, hit$cyan q$orange"
    htop
;;

u|U|udev|UDEV)

    if grep -q udev-end $dp/installed.conf ; then
    announce "udev already installed."
    return 0
    fi
    udev
;;
fb|FB)
get_books
;;

*)
    invalid
    continue
    ;;
esac
done

return 0

}

