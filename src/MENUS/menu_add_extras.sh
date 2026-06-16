function menu_add_extras {
while true ; do
menu_add_source
if [[ -e $hp/parman_books ]] ; then UPDATE="${red}UPDATE$orange " ; endline="                  #" ; else unset UPDATE ; endline="                         #"; fi

if ! grep -q "parmaview-end" $ic ; then 
parmaviewmenu="\n#$cyan              pv)$orange      ParmaView (web interface, coming soon)                         #
#                                                                                      #"
unset pvremove
elif grep -q "parmaview-end" $ic ; then 
unset parmaviewmenu pvremove
elif grep -q "parmaview-start" $ic ; then
pvremove=1
parmaviewmenu="\n#$cyan              pv)$red      REMOVE ParmaView failed install                                $orange#
#                                                                                      #"
fi

if  ! grep -q "veracrypt-end" $ic ; then
veracryptview="\n#$cyan              vc)$orange      VeraCrypt - disk encryption tool                               #
#                                                                                      #"
else
unset veracryptview
fi


set_terminal
echo -en "
########################################################################################
#                                                                                      #
#    P A R M A N O D E --> Main Menu --> Install Menu  -->$cyan Extras        $orange              #
#                                                                                      #
########################################################################################
#                                                                                      #
#                                                                                      #
#$cyan              h)$orange       HTOP - check system resources                                  #
#                                                                                      #
#$cyan              udev)$orange    Add UDEV rules for HWWs (only needed for Linux)                #
#                                                                                      #
#$cyan              pb)$orange      ${UPDATE}Parman's recommended free books (pdfs)$endline
#                                                                                      #
#                                                                                      #$veracryptview$parmaviewmenu
########################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) menu_add ;; m|M) back2main ;;

vc)
if [[ -n $veracryptview ]] ; then
install_veracrypt
fi
;;

pv)
[[ -z $parmaviewmenu ]] && invlid && continue

if [[ $pvremove == 1 ]] ; then uninstall_parmaview ; continue ; fi

! [[ -f $dp/.parmaview_enabled ]] && { announce "Not available yet, hang in there, it'll be worth it." ; continue ; }
install_parmaview
;;

pnas)
    [[ ! -e $dp/.parmanas_enabled ]] && {
    announce "ParmaNas is not enabled by default in Parmanode; it is a
    premium feature. Contact Parman for more info."
    continue
    }

    if ! grep -q "parmanas-end" $ic ; then
    git@github.com:armantheparman/parmanas.git $pp/parmanas || { enter_continue "Something went wrong. Contact Parman." ; continue ; }
    fi

    cd $pp/parmanas
    ./run_parmanas.sh

;;
h|H|htop|HTOP|Htop)

    if [[ $OS == "Mac" ]] ; then htop ; break ; return 0 ; fi
    if ! which htop ; then sudo apt-get install htop -y >$dn 2>&1 ; fi
    announce "To exit htop, hit$cyan q$orange"
    htop
;;

udev|UDEV)

    if grep -q udev-end $dp/installed.conf ; then
    announce "udev already installed."
    return 0
    fi
    udev
;;
pb|fb|FB)
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

