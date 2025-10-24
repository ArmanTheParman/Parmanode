function menu_premium {
while true ; do
unset parminer parmacloud parmanas another parmascale parmaweb parmaraid datum parmasync uddns plex parmasql parmatwin
menu_add_source
if ! grep -q "parmaplex-end" $ic ; then plex="\n#$orange              plex)$blue        ParmaPlex (Plex Media Server)                              #
#                                                                                      #"
fi
[[ ! -e $pp/parmasql ]]   &&          parmasql="\n#$orange              psql)$blue        ParmaSQL                                                   #
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
[[ ! -e $pp/datum ]] &&        datum="\n#$orange                dt)$blue        Datum-Gateway-Parmanode $green only 42 sats!$blue                     #
#                                                                                      #"
[[ ! -e $pp/parmasync ]] &&      parmasync="\n#$orange              sync)$blue        ParmaSync - Backup to a remote ParmaTwin                   #
#                                                                                      #"
[[ ! -e $pp/parmatwin ]] &&      parmatwin="\n#$orange              twin)$blue        ParmaTwin - Be a data server for a ParmaSync Computer      #
#                                                                                      #"
[[ ! -e $pp/uddns ]] &&                  uddns="\n#$orange                ud)$blue        UDDNS - Parman's Uncomplicated Dynamic DNS Service         #
#                                                                                      #"
set_terminal
echo -en "$blue
########################################################################################
#$orange               PREMIUM FEATURES AVAILABLE FOR A SMOL FEE:$green CONACT PARMAN          $blue     #
########################################################################################
#                                                                                      #
#                                                                                      #$parmasync$parmatwin$parmascale$datum$parmanas$parminer$parmacloud$parmaweb$parmaraid$uddns$parmasql$plex
#                                                                                      #
########################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) menu_add ;; m|M) back2main ;;
sync)
get_parmasync
debug after install
;;
twin)
get_parmatwin
debug after install
;;
scale)
get_parmascale
debug after install
;;

pnas)
get_parmanas
debug after install
;;

cloud)
get_parmacloud
debug after install
;;

pm)
get_parminer
debug after install
;;

web)
get_parmaweb
debug after install
;;

pr)
get_parmaraid
debug after install
;;

dt)
get_datum
debug after install
;;

ud)
get_uddns
debug after install
;;

psql)
get_parmasql
debug after install
;;

plex)
get_parmanpremium plex
debug after install
;;
*)
    invalid
    continue
    ;;
esac
done

return 0

}
