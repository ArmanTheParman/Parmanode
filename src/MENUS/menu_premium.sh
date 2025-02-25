function menu_premium {
while true ; do
unset parminer parmacloud parmanas another
menu_add_source
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
[[ ! -e $pp/parmaraid ]] &&        parmaraid="\n#$orange                pr)$blue        ParmaRAID                                                  #
#                                                                                      #"


set_terminal
echo -en "$blue
########################################################################################
#$orange               PREMIUM FEATURES AVAILABLE FOR A FEE:$green CONACT PARMAN          $blue          #
########################################################################################
#                                                                                      #
#                                                                                      #$parmanas$parminer$parmacloud$parmaweb$parmaraid
#                                                                                      #
#                                                                                      #
########################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 0 ;; m|M) back2main ;;

pnas)
#If ParmaNas is not enabled, show the message and continue
    [[ ! -e $dp/.parmanas_enabled ]] && {
    announce_blue "ParmaNas (Network Attached Storage) is not enabled by default in Parmanode.

    It comes with all purchased fully-synced ParmanodL laptops and ParmaCloud machines 
    (16TB self-hosted cloud data + Parmanode Bitcoin Node.)

    Contact Parman for more info, or see...
$green
    https://parmanode.com/parmanodl$blue"

    continue
    }
#If ParmaNas is enabled, make the SSH keys and continue
make_parmanas_ssh_keys && { announce_blue "Parmanas SSH keys made. Please contact Parman to enable." ; continue ; }

#If ParmaNas is enabled and SSH keys are made, clone the repo and run the script

    if [[ ! -d $pp/parmanas ]] ; then
    git clone git@github.com:armantheparman/parmanas.git $pp/parmanas || { enter_continue "\n$blue    Something went wrong. Contact Parman.\n
    \r    Please contact Parman to enable ParmaNas on your machine.\n$orange" ; continue ; }
    else
    cd $pp/parmanas && please_wait && git pull >$dn 2>&1
    fi

    $pp/parmanas/run_parmanas.sh
;;

cloud)
  [[ ! -e $dp/.parmacloud_enabled ]] && announce_blue "

    With NextCloud, your machine can host your files like a Google Drive server,
    and you can access them from anywhere via your preferred domain name.    

    Contact Parman for set up. Fee is \$US400.$blue" && continue 

make_parmacloud_ssh_keys && { announce_blue "ParmaCloud SSH keys made. Please contact Parman to enable." ; continue ; }

[[ ! -e $pp/parmacloud ]] && { 
    git clone git@github-parmacloud:armantheparman/parmacloud.git $pp/parmacloud || {
        enter_continue "Please contact Parman to enable ParmaCloud on your machine.\n$orange" ; continue ; 
    } #requires SSH key authority 
}
installed_conf_add "parmacloud-start"
for file in $pp/parmacloud/src/*.sh ; do source $file ; done
install_parmacloud
debug "pause"
;;

pm)
get_parminer
;;

web)
[[ ! -e $dp/.parmaweb_enabled ]] && announce_blue "
    With Parmaweb, you can host your own WordPress Server (Linux Only)
    with a database configured, help with reverse proxying if you need it
    and free domain name (or buy your own)$orange yourchoice.parmacloud.com$blue
    
    Contact Parman for setup. Fee is \$500 USD." && continue

[[ -n $another ]] && make_parmaweb_ssh_keys && { announce_blue "ParmaWeb SSH keys made" ; continue ; }

git clone git@github-parmaweb:armantheparman/parmaweb.git $pp/parmaweb 2>$dn || {
cd $pp/parmaweb && git pull >$dn 2>&1 ; } || \
{ enter_continue "Please contact Parman to enable ParmaWeb on your machine.\n$orange" ; continue ; } #requires SSH key authority

for file in $pp/parmaweb/src/*.sh ; do
source $file
done

install_website
return 0

;;
pr)
install_raid
;;

*)
    invalid
    continue
    ;;
esac
done

return 0

}