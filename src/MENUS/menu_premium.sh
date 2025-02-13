function menu_premium {
while true ; do
unset parminer parmacloud parmanas
menu_add_source
[[ ! -e $pp/parminer ]] && parminer="\n#$orange                pm)$blue        ParMiner                                                   #
#                                                                                      #"
[[ ! -e $pp/parmacloud ]] && parmacloud="\n#$orange             cloud)$blue        ParmaCloud                                                 #
#                                                                                      #"
[[ ! -e $pp/parmanas ]] && parmanas="\n#$orange              pnas)$blue        ParmaNas - Network Attached Storage                        #
#                                                                                      #"

set_terminal
echo -en "$blue
########################################################################################
#$orange        PREMIUM FEATURES AVAILABLE FOR A FEE:$green CONACT PARMAN          $blue #
########################################################################################
#                                                                                      #
#                                                                                      #$parmanas$parminer$parmacloud
#$orange                rr)$blue        RAID - join drives together                                #
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

    if [[ ! -d $pp/parmanas ]] ; then
    git clone git@github.com:armantheparman/parmanas.git $pp/parmanas || { enter_continue "\n$blue    Something went wrong. Contact Parman.\n
    \r    It's possible you were trying to install ParmaNas before Parman has had a chance
    \r    to approve your computer's credentials.\n$orange" ; continue ; }
    else
    cd $pp/parmanas && please_wait && git pull >$dn 2>&1
    fi

    $pp/parmanas/run_parmanas.sh
;;
cloud)
  [[ ! -e $dp/.parmacloud_enabled ]] && announce "

    With NextCloud, your machine can host your files like a Google Drive server,
    and you can access them from anywhere via your preferred domain name.    

    Contact Parman for set up. Fee is \$US400." && continue 

[[ ! -e $pp/parmacloud ]] && { 
    git clone git@github.com:armantheparman/parmacloud.git $pp/parmacloud || {
        enter_continue "Something went wrong" ; continue ; 
    } #requires SSH key authority 
}
for file in ./parmacloud/src/*.sh ; do source $file ; done
install_nextcloud
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

