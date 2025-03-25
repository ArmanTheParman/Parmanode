function menu_premium {
while true ; do
unset parminer parmacloud parmanas another
menu_add_source
[[ ! -e $pp/parmaswap ]] &&          parmaswap="\n#$orange              swap)$blue        ParMiner                                                   #
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
[[ ! -e $pp/remotevault ]] &&      remotevault="\n#$orange                rv)$blue        RemoteVault - encryption and remote backup                 #
#                                                                                      #"
[[ ! -e $pp/uddns ]] &&                  uddns="\n#$orange                ud)$blue        UDDNS - Parman's Uncomplicated Dynamic DNS Service         #
#                                                                                      #"
set_terminal
echo -en "$blue
########################################################################################
#$orange               PREMIUM FEATURES AVAILABLE FOR A SMOL FEE:$green CONACT PARMAN          $blue     #
########################################################################################
#                                                                                      #
#                                                                                      #$parmaswap$datum$parmanas$parminer$parmacloud$parmaweb$parmaraid$uddns$remotevault
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
pnas)
#If ParmaNas is not enabled, show the message and continue
    [[ ! -e $dp/.parmanas_enabled ]] && {
    announce_blue "${cyan}ParmaNas (Network Attached Storage) is not enabled by default in Parmanode.

    It comes with all purchased fully-synced ParmanodL laptops and ParmaCloud machines 
    (16TB self-hosted cloud data + Parmanode Bitcoin Node.)

    Contact Parman for more info, or see...
$green
    https://parmanode.com/parmanodl$blue"

    continue
    }
#If ParmaNas is enabled, make the SSH keys and continue
make_parmanas_ssh_keys && { announce_blue "Parmanas SSH keys made. Please contact Parman to enable.
$green

$HOME/.ssh/extra_keys/parmanas-key ...

$(cat ~/.ssh/extra_keys/parmanas-key.pub)$blue\n" ; continue ; }

#If ParmaNas is enabled and SSH keys are made, clone the repo and run the script

    if [[ ! -d $pp/parmanas ]] ; then
    git clone git@github-parmanas:armantheparman/parmanas.git $pp/parmanas || { enter_continue "\n$blue    Something went wrong. Contact Parman.\n
    \r    Please contact Parman to enable ParmaNas on your machine.\n$orange" ; continue ; }
    else
    cd $pp/parmanas && please_wait && git pull >$dn 2>&1
    fi

    $pp/parmanas/run_parmanas.sh
;;

cloud)
  [[ ! -e $dp/.parmacloud_enabled ]] && announce_blue "$cyan

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
[[ ! -e $dp/.parmaweb_enabled ]] && announce_blue "${cyan}With Parmaweb, you can host your own WordPress Server (Linux Only)
    with a database configured, help with reverse proxying if you need it
    and free domain name (or buy your own)$orange yourchoice.parmacloud.com$blue
    
    Contact Parman for setup. Fee is \$500 USD." && continue

[[ -z $another ]] && make_parmaweb_ssh_keys && { announce_blue "ParmaWeb SSH keys made" ; continue ; }

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
[[ ! -e $dp/.parmaraid_enabled ]] && parmaraid_info && continue

make_parmaraid_ssh_keys && { announce_blue "ParmaRaid SSH keys made" ; continue ; }

git clone git@github-parmaraid:armantheparman/parmaraid.git $pp/parmaraid 2>$dn ||
{ cd $pp/parmaraid 2>$dn && git pull >$dn 2>&1 ; } ||
{ enter_continue "Please contact Parman to enable ParmaRaid on your machine.\n$orange" ; continue ; } #requires SSH key authority

for file in $pp/parmaraid/src/*.sh ; do
source $file
done

install_raid
return 0
;;

dt)
#if [[ $(uname -m) != "x86_64" ]] ; then  { announce_blue "Datum is only supported on x86_64 machines at this stage." ; continue ; } ; fi
[[ -e $dp/.datum_enabled ]]  || {
please_wait
make_datum_ssh_keys
announce_blue "
    To install Datum with Parmanode, please send$green 42 sats$blue over lightning via 
    NOSTR zap, or the donations page:

$cyan    https://armantheparman.com/donations $blue

    Then send lightning invoice to Parman by email$cyan armantheparman@protonmail.com$blue, and 
    send the following custom ssh key...
   "

announce_blue "$cyan$(cat $HOME/.ssh/extra_keys/datum-key.pub)$blue"

announce_blue "
    For pre-configurd Bitcoin Knots, ParMiner and Datum, please see...
$orange
        https://parmanode.com/parmanodl 
$blue
        or 
$orange
        https://parmanode.com/parmadrive $blue "

debug "pause"
continue
}

git clone git@github-datum:armantheparman/datum_parmanode.git $pp/datum 2>$dn || {
cd $pp/datum && git pull >$dn 2>&1 ; } || \
{ enter_continue "Please contact Parman to enable Datum on your machine.\n$orange" ; continue ; } #requires SSH key authority

for file in $pp/datum/src/*.sh ; do
source $file
done
menu_datum
return 0
;;

rv)
#[[ ! -e $dp/.remotevault_enabled ]] && remotevault_info && continue
remotevault_info
;;

ud)
[[ ! -e $dp/.uddns_enabled ]] && announce_blue "No static IP? No problem. With UDDNS, you can simiulate a static IP address for
                                          \r    your machine. Fee is cheap AF, 1.5k sats per month, paid yearly (18k sats)." && continue

git clone git@github-uddns:armantheparman/uddns.git $pp/uddns 2>$dn || { enter_continue "Something went wrong. Contact Parman." ; continue ; }
installed_conf_add "uddns-end"
for file in $pp/uddns/src/*.sh ; do source $file ; done
menu_uddns
return 0
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