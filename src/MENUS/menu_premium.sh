function menu_premium {
while true ; do
menu_add_source
set_terminal
echo -en "$blue
########################################################################################
#                                                                                      #
#    P A R M A N O D E --> Main Menu --> Install Menu  -->$cyan Premium      $blue               #
#                                                                                      #
########################################################################################
#                                                                                      #
#                                                                                      #
#$orange                pm)$blue        ParMiner                                                   #
#                                                                                      #
#$orange              pnas)$blue        ParmaNas - Network Attached Storage                        #
#                                                                                      #
#$orange                rr)$blue        RAID - join drives together                                #
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

pnas)
    [[ ! -e $dp/.parmanas_enabled ]] && {
    announce "ParmaNas (Network Attached Storage) is not enabled by default in Parmanode.

    It comes with all purchased fully-synced ParmanodL laptops and ParmaCloud machines 
    (16TB self-hosted cloud data + Parmanode Bitcoin Node.)

    Contact Parman for more info, or see...
$blue    
    https://parmanode.com/parmanodl$orange"

    continue
    }

    if ! grep -q "parmanas-end" $ic ; then
    git clone git@github.com:armantheparman/parmanas.git $pp/parmanas || { enter_continue "\n$blue    Something went wrong. Contact Parman.\n
    \r    It's possible you were trying to install ParmaNas before Parman has had a chance
    \r    to approve your computer's credentials.\n$orange" ; continue ; }
    fi

    $pp/parmanas/run_parmanas.sh

;;

pm)
get_parminer
;;


*)
    invalid
    continue
    ;;
esac
done

return 0

}