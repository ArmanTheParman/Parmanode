function menu_premium {
while true ; do
unset parminer parmacloud parmanas another parmascale parmaweb parmaraid datum parmasync uddns
menu_add_source
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
unset parmasync 
[[ ! -e $pp/parmasync ]] &&      parmasync="\n#$orange              sync)$blue        ParmaSync - reciprical backup with remote ParmaTwin        #
#                                                                                      #"
unset uddns
[[ ! -e $pp/uddns ]] &&                  uddns="\n#$orange                ud)$blue        UDDNS - Parman's Uncomplicated Dynamic DNS Service         #
#                                                                                      #"
debug "pre-premium"
set_terminal
echo -en "$blue
########################################################################################
#$orange               PREMIUM FEATURES AVAILABLE FOR A SMOL FEE:$green CONACT PARMAN          $blue     #
########################################################################################
#                                                                                      #
#                                                                                      #$parmasync$parmascale$datum$parmanas$parminer$parmacloud$parmaweb$parmaraid$uddns
#                                                                                      #
########################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) menu_add ;; m|M) back2main ;;
sync)
get_parmasync
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

# function remotevault_info {
#     announce_blue "${cyan}With RemoteVault, you can encrypt and back up your data to a remote server.

#     To be part of the RemoteVault pilot, please contact Parman.$blue" && return 0
# }