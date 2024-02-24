function make_bitcoin_conf {
debug "in make bitcoin conf. bdi= $bitcoin_drive"

if [[ $1 == prune ]] ; then export prune=$2 ; fi #assumes aruguments are "prune" "[0-9].*"

#Parmanode default config settings. Can be changed.
#Create a bitcoin.conf file in data directory.
#Overrides any existing file named bitcoin.conf
set_terminal

cat << EOF > /tmp/bitcoin.conf
server=1
txindex=1
rpcservertimeout=120
blockfilterindex=1
daemon=1
rpcport=8332

zmqpubrawblock=tcp://127.0.0.1:28332
zmqpubrawtx=tcp://127.0.0.1:28333

whitelist=127.0.0.1
rpcbind=0.0.0.0
rpcallowip=127.0.0.1
rpcallowip=10.0.0.0/8
rpcallowip=192.168.0.0/16
rpcallowip=172.0.0.0/8
EOF

if [[ -n $IP ]] && [[ $(echo "$IP" | wc -l | tr -d ' ' ) == 1 ]] && echo $IP | grep -qE '^[0-9]' ; then 
IP1="$(echo "$IP" | cut -d \. -f 1 2>/dev/null)" 
IP2="$(echo "$IP" | cut -d \. -f 2 2>/dev/null)"
IP1and2="$IP1.$IP2." 
echo rpcallowip="${IP1and2}0.0/16" | tee -a /tmp/bitcoin.conf >/dev/null 2>&1
fi

debug "check bitcoin conf in /tmp made"

file="$HOME/.bitcoin/bitcoin.conf"
loop=do
if [[ $1 == umbrel ]] ; then export prune=0 ; loop="break" ; file="$mount_point/.bitcoin/bitcoin.conf" ; fi



if [[ -e $HOME/.bitcoin/bitcoin.conf ]] # if a bitcoin.conf file exists
	then 

        while true ; do
        if [[ $installer == parmanodl || $loop == "break" ]] ; then export prune=0 ; break ; fi #overwrites any existing conf file 
	    set_terminal ; echo -e "
########################################################################################

    A$cyan bitcoin.conf$orange file already exists. You can keep the one you have, but be
    aware if this file was not originally birthed by Parmanode, it may cause conflicts
    if there are unexpected settings. Your prune choice will still be added to it if
    you made one.

    It's probably safest to discard the old copy, but the choice is yours...

                           o)           overwrite

                           yolo)        keep the one you have

                           a)           abort installation

########################################################################################
"
choose "xpmq" ; read choice

case $choice in 
m|M) back2main ;;
    q|Q|QUIT|Quit|quit) exit 0 ;; 
    p|P) return 1 ;; 
    o|O) log "bitcoin" "conf overwrite" && break ;;
    yolo|YOLO|Yolo) apply_prune_bitcoin_conf ; return 0 ;; 
    *) invalid ;; 
esac 
done
fi

sudo cp /tmp/bitcoin.conf $file && log "bitcoin" "bitcoin conf made"  
debug "after copy tmp to bc"
sudo chown -R $USER:$(id -gn) $file
debug "conf file copied from tmp"
apply_prune_bitcoin_conf "$@" # Here is where the prune choice is added to bitcoin.conf
}
