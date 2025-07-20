function make_bitcoin_conf {

if [[ $1 == prune ]] ; then export prune=$2 ; fi #assumes arguments are "prune" "[0-9].*"

#Parmanode default config settings. Can be changed.
#Create a bitcoin.conf file in data directory.
#Overrides any existing file named bitcoin.conf
set_terminal

#onlynet=ipv4 is for clearnet, =i2p and =onion also possilbe. Can have more than one. Omitting onlynet allows all.
#proxy=127.0.0.1:9050 is need for i2p even though it doesn't use it.
#listenonion=1 is default, needs to be off to disable tor

cat << EOF > $tmp/bitcoin.conf
server=1
txindex=1
daemon=1
blockfilterindex=1
rpcport=8332
rpcuser=parman
rpcpassword=parman
zmqpubrawblock=tcp://*:28332
zmqpubrawtx=tcp://*:28333

whitelist=127.0.0.1
rpcbind=0.0.0.0
rpcallowip=127.0.0.1
rpcallowip=10.0.0.0/8
rpcallowip=192.168.0.0/16
rpcallowip=172.16.0.0/12

rpcservertimeout=120
assumevalid=00000000000000000001347938c263a968987bf444eb9596ab0597f721e4e9e8 #hash for block 888,888


EOF

# Makes sure the internal IP is allowed to connect to the RPC server
if [[ -n $IP ]] && [[ $(echo "$IP" | wc -l | tr -d ' ' ) == 1 ]] && echo $IP | grep -qE '^[0-9]' ; then 
IP1="$(echo "$IP" | cut -d \. -f 1 2>$dn)" 
IP2="$(echo "$IP" | cut -d \. -f 2 2>$dn)"
IP1and2="$IP1.$IP2." 
echo rpcallowip="${IP1and2}0.0/16" | tee -a $tmp/bitcoin.conf >$dn 2>&1
fi

#bitcoin conf path to be modified can vary depending on the calling function, normal call or umbrel
if [[ $1 == umbrel ]] ; then 
    export prune=0 
    loop="break" 
    file="$mount_point/.bitcoin/bitcoin.conf" 
else
    file="$HOME/.bitcoin/bitcoin.conf"
    loop=do
fi


# umbrel has loop-break, so will exit early anyway
if [[ -e $HOME/.bitcoin/bitcoin.conf ]] ; then while true ; do

    if [[ $installer == parmanodl || $loop == "break" ]] ; then export prune=0 ; break ; fi #overwrites any existing conf file 
    
    if [[ $btcpayinstallsbitcoin != "true" && $btcdockerchoice != "yes" ]] || [[ $btcpay_combo == "true" ]] ; then

if [[ $1 == "refresh" ]] ; then
    yesorno "Would  you like to refresh your bitcoin.conf file to the Parmanode default?" || return 1
    gsed -i '/prune_value=/d' $pc
    unset prune_value
    source $pc
    break
fi

set_terminal ; echo -e "
########################################################################################

    A$cyan bitcoin.conf$orange file already exists. You can keep the one you have, but be
    aware if this file was not originally birthed by Parmanode, it may cause conflicts
    if there are unexpected settings. 

    It's probably safest to discard the old copy, but the choice is yours...
$green
                           o)           overwrite
$orange
                           yolo)        keep the one you have
$red
                           a)           abort installation
$orange
########################################################################################
"
choose "xpmq" ; read choice
else
choice=o
fi
jump $choice 
case $choice in 
m|M) back2main ;;
    q|Q|QUIT|Quit|quit) exit 0 ;; 
    a|A|p|P) return 1 ;; 
    o|O) break ;;
    yolo|YOLO|Yolo) apply_prune_bitcoin_conf ; return 0 ;; 
    *) invalid ;; 
esac 
done ; fi

sudo cp $tmp/bitcoin.conf $file && log "bitcoin" "bitcoin conf made"  
debug "Bitcoin conf copied from tmp
$(cat $HOME/.bitcoin/bitcoin.conf)"

sudo chown -R $USER:$(id -gn) $file

# Here is where the prune choice is added to bitcoin.conf
#currently only "umbre" is the supported argument
apply_prune_bitcoin_conf "$@" 
}

########################################################################################
#bitcoin conf patches
########################################################################################

function add_rpcbind {
[[ -e $bc ]] && if ! grep -q "rpcbind=0.0.0.0" $bc >$dn 2>&1 ; then 
echo "rpcbind=0.0.0.0" | sudo tee -a $bc >$dn 2>&1
fi
}

function fix_bitcoin_conf {

if [[ ! -e $bc ]] ; then return 0 ; fi

add_rpcbind

#values below 172.16 are public internet reserved, and above are private networks
[[ -e $bc ]] && if ! grep -q "rpcallowip=172.16" $bc ; then 
    sudo gsed -i '/rpcallowip=172.*$/d' $bc
    echo "rpcallowip=172.16.0.0/12"  | sudo tee -a $bc >$dn 2>&1
fi

}
