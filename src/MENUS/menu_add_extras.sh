function menu_add_extras {
while true ; do
menu_add_source
if [[ -e $hp/parman_books ]] ; then UPDATE="${red}UPDATE$orange " ; endline="                  #" ; else unset UPDATE ; endline="                         #"; fi

if ! grep -q "parmaview-end" $ic ; then 
parmaviewmenu="\n#$cyan              pv)$orange      ParmaView (web interfact, coming soon)                         #
#                                                                                      #"
elif grep -q "parmaview-start" $ic ; then
parmaviewmenu="\n#$cyan              pv)$red      REMOVE ParmaView failed install                                #$orange
#                                                                                      #"
else
unset parmaviewmnu
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
#$cyan              cl)$orange      Core Lightning                                                 #
#                                                                                      #$parmaviewmenu
########################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 0 ;; m|M) back2main ;;

pv)
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

cl)
announce "Parmanode isn't configured to support Core Lightning, but it can install it for
    you. This means that any conflicts with other Parmanode-installed software will 
    not be checked for or managed.

    To install Core Lightning, it is recommended you uninstall LND, make sure Bitcoin 
    is installed and running, then exit parmanode and restart it with this command: $cyan

            rp install_core_lightning
    $orange
    To uninstall, do:$cyan
            
            rp uninstall_core_lightning
    $orange
    This will start the installation, and will get you to hit <enter> at various 
    stages, as it downloads files and compiles from source.

    There won't be any menus in Parmanode, you'll need to interact with it by the 
    command line or other means. Core Lightning may be implemende within Parmanode in 
    the future." 
;;

*)
    invalid
    continue
    ;;
esac
done

return 0

}

