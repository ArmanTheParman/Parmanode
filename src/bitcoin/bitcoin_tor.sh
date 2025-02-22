function bitcoin_tor {
nogsedtest
install_tor

if [[ ! -e $varlibtor ]] ; then mkdir -p $varlibtor >$dn 2>&1 ; fi
if [[ ! -e $torrc ]] ; then sudo touch $torrc >$dn 2>&1 ; fi

#start fresh
sudo gsed -i "/onion/d" $bc
sudo gsed -iE "/^bind=/d" $bc
sudo gsed -i "/onlynet/d" $bc
sudo gsed -i "/listenonion=1/d" $bc

enable_tor_general

if ! grep "listen=1" $bc >$dn 2>&1 ; then
    echo "listen=1" | sudo tee -a $bc >$dn 2>&1
fi

if ! sudo grep "HiddenServiceDir $varlibtor/bitcoin-service/" $torrc | grep -v "^#" >$dn 2>&1 ; then 
    echo "HiddenServiceDir $varlibtor/bitcoin-service/" | sudo tee -a $torrc >$dn 2>&1
fi

if ! sudo grep "HiddenServicePort 8333 127.0.0.1:8333" $torrc | grep -v "^#" >$dn 2>&1 ; then 
    echo "HiddenServicePort 8333 127.0.0.1:8333" | sudo tee -a $torrc >$dn 2>&1
fi

########################################################################################
#Need the Onion address
#Bitcoind stopping - start it up inside this function later

    restart_tor

    stop_bitcoin
    add_rpcbind #modifications might inadvertently delete rpcbind
    start_bitcoin

unset $ONION_ADDR
while [[ -z $ONION_ADDR ]] ; do
if [[ $count -gt 0 ]] ; then echo "will try up to 12 times while it thinks" ; fi
get_onion_address_variable "bitcoin"
sleep 1.5
count=$((1 + count))
if [[ $count -gt 12 ]] ; then announce "Couldn't get onion address. Aborting." ; return 1 ; fi
done
########################################################################################


if [[ $1 == "torandclearnet" ]] ; then
    sudo gsed -i "/onion=/d" $bc
    echo "onion=127.0.0.1:9050" | sudo tee -a $bc >$dn 2>&1
    echo "listenonion=1" | sudo tee -a $bc >$dn 2>&1
    sudo gsed -i "/externalip=/d" $bc
    echo "externalip=$ONION_ADDR" | sudo tee -a $bc >$dn 2>&1
    sudo gsed -i "/discover=/d" $bc
    echo "discover=1" | sudo tee -a $bc >$dn 2>&1
    fi

if [[ $1 == "toronly" ]] ; then
    sudo gsed -i "/onion=/d" $bc
    echo "onion=127.0.0.1:9050" | sudo tee -a $bc >$dn 2>&1
    echo "listenonion=1" | sudo tee -a $bc >$dn 2>&1
    sudo gsed -i "/externalip=/d" $bc
    debug "onion is $ONION_ADDR"
    echo "externalip=$ONION_ADDR" | sudo tee -a $bc >$dn 2>&1
    sudo gsed -i "/bind=/d" $bc
    echo "bind=127.0.0.1" | sudo tee -a $bc >$dn 2>&1
    rpcbind_adjust
    fi

if [[ $2 == "onlyout" ]] ; then
    sudo gsed -i "/onlynet/d" $bc
    sudo gsed -i "/listenonion=1/d" $bc
    echo "listenonion=1" | sudo tee -a $bc >$dn 2>&1
    echo "onlynet=onion" | sudo tee -a $bc >$dn 2>&1
    rpcbind_adjust
    fi

restart_tor
stop_bitcoin
start_bitcoin

set_terminal ; 
success "Changes have been made to torrc file & bitcoin.conf file,
    and Tor has been restarted."
}


function rpcbind_adjust {

yesorno "Because you're enabled strict privacy settings for Bitcoin with Tor, RPC 
    calles (ie wallet and other software trying to communicate with Bitcoin) will not
    be permitted by default.

    You need to add the permitted IPs one by one to the bitcoin.conf file.

    No worries, I'll help you.$cyan Do you want to continue with this? $orange" \
    || { announce "Or, just hit$red q$orange and$cyan <enter> $orange to quit."
    case $enter_cont in q) exit ;; esac
    jump $enter_cont
    }

#question 1 - localhost
yesorno "${green}Question 1: 
$orange
    Do you want to add the IP address of the computer you're on right now? i.e the
    do you want software on your computer to communicate with Bitcoin software?
    This is the IP $IP and 127.0.0.1.
    
    The line that will be added is...
   $cyan 
    rpcbind=127.0.0.1$orange" &&
echo "rpcallowip=$IP" | sudo tee -a $bc >$dn 2>&1


#question 2 - docker containers that are running
docker ps 2>/dev/null | tail -n1 | awk '{print $1}' | grep -q CONTAINER || \
yesorno "${green}Question 2:
$orange
    Do you want to add this/these Docker IP address(es) to the bitcoin.conf file?
$green
$(docker inspect -f '{{.Name}} - {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker ps -q) | gsed 's/^\///')
$orange
    You can decline and add them yourself later, or manually delete them.
" &&
docker inspect -f '{{.Name}} - {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker ps -q) \
| awk '{print $3}' | while read theip ; do echo rpcbind=$theip | tee -a $bc ; done

#question 3 - another computer on the network
while true ; do
announce "${green}Question 3 (on loop):
$orange
    Do you want to add the IP address of any another computer on your network?$orange
    Just enter the IP address and hit $cyan<enter>.$orange

    Otherwise, just hit enter to exit the loop."
case $enter_cont in
    "") break ;;
    *) if echo $enter_cont | grep -qE "^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$" ; then
            echo "rpcallowip=$enter_cont" | sudo tee -a $bc >$dn 2>&1
            continue
        else
            announce "That doesn't look like an IP address. Try again."
            continue
        fi 
        ;;
esac
return 0
done 
} 
    