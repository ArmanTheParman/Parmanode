function menu_premium {
while true ; do
unset parminer parmacloud parmanas another
menu_add_source
[[ ! -e $pp/parmaswap ]] &&          parmaswap="\n#$orange              swap)$blue        ParmaSwap                                                  #
#                                                                                      #"
[[ ! -e $pp/parmascale ]] &&          parmascale="\n#$orange             scale)$blue        ParmaScale                                                 #
#                                                                                      #"
[[ ! -e $pp/parminer ]] &&          parminer="\n#$orange                pm)$blue        ParMiner                                                   #
#                                                                                      #"
[[ ! -e $pp/parmacloud ]] &&      parmacloud="\n#$orange             cloud)$blue        ParmaCloud                                                 #
#                                                                                      #"
[[ ! -e $pp/parmanas ]] &&          parmanas="\n#$orange              pnas)$blue        ParmaNas - Network Attached Storage                        #
#                                                                                      #"
if ! grep -q "website-" $ic 2>$dn ; then  parmaweb="\n#$orange               web)$blue        ParmaWeb                                                   #
#                                                                                      #"
else
    parmaweb="\n#$orange               web)$blue        ParmaWeb (add another)                                     #
#                                                                                      #"
another="true"
fi
parmaraid="\n#$orange                pr)$blue        ParmaRAID                                                  #
#                                                                                      #"
unset datum
[[ ! -e $pp/datum ]] &&        datum="\n#$orange                dt)$blue        Datum-Gateway-Parmanode $green only 42 sats!$blue                     #
#                                                                                      #"
unset remotevault
[[ ! -e $pp/remotevault ]] &&      remotevault="\n#$orange                rv)$blue        RemoteVault - encryption and remote backup                 #
#                                                                                      #"
unset uddns
[[ ! -e $pp/uddns ]] &&                  uddns="\n#$orange                ud)$blue        UDDNS - Parman's Uncomplicated Dynamic DNS Service         #
#                                                                                      #"
set_terminal
echo -en "$blue
########################################################################################
#$orange               PREMIUM FEATURES AVAILABLE FOR A SMOL FEE:$green CONACT PARMAN          $blue     #
########################################################################################
#                                                                                      #
#                                                                                      #$parmaswap$parmascale$datum$parmanas$parminer$parmacloud$parmaweb$parmaraid$uddns$remotevault
#                                                                                      #
########################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 0 ;; m|M) back2main ;;
swap)
[[ ! -e $dp/.parmaswap_enabled ]] && 
announce_blue "ParmaSwap is a remote backup swap service allowing you and a friend/family
    memeber, or even a stranger, to dedicate a portion of your hard drive for automatic
    encrypted remote backups over an \"encrypted tunnel\", while they do the same for you.

    This allows you to distribute your data loss risk, and avoid the need to sacrifice 
    your privacy for a cloud backup service, and the associated high fees.

    Your data backup partner will not see your data, nor your location.

    This service is configured for ParmaDrive clients on request, and no extra fee
    is required. To purchase a ParmaDrive, see this page for choices...
    $cyan
        https://parmanode.com/parmadrive$blue
      "
;;
scale)
get_parmascale
;;

pnas)
get_parmanas
;;

cloud)
get_parmacloud
;;

pm)
get_parminer
;;

web)
get_parmaweb
;;

pr)
get_parmaraid
;;

dt)
get_datum
;;

rv)
#[[ ! -e $dp/.remotevault_enabled ]] && remotevault_info && continue
remotevault_info
;;

ud)
get_uddns
;;

*)
    invalid
    continue
    ;;
esac
done

return 0

}

function remotevault_info {
    announce_blue "${cyan}With RemoteVault, you can encrypt and back up your data to a remote server.

    To be part of the RemoteVault pilot, please contact Parman.$blue" && return 0
}