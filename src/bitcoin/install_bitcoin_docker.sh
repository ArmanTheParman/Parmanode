function install_bitcoin_docker {
set_terminal
yesorno "You are about to install Bitcoin into a docker container of your
    choice." || return 1
set_terminal

if ! docker ps 2>/dev/null ; then announce "Docker is not running" ; return 1 ; fi

if [[ -z $1 ]] ; then

    while true ; do

    set_terminal
    echo -e "
########################################################################################

    Please type the name of the running Docker container you want to use (case
    sensitive). These are the running containers...
$green    
$(docker ps --format "{{.Names}}")
$orange
########################################################################################
"
read dockername

        case $dockername in
        Q|q) exit ;; p|P) return 1 ;; m|M) back2main ;;
        "")
        invalid 
        ;;
        *)
        if docker ps | grep -q $dockername ; then
            yesorno "You have chosen the$red $dockername$orange container." && break
        else
            announce "This container is not running" ; continue
        fi
        ;;
        esac
    done

    export dockername

else
    export dockername=${1}
fi

debug "dockername is $dockername"
clear
#USER choice
while true ; do
set_terminal ; echo -e "
########################################################################################

    Please choose the user name for the intallation. If you choose 'root' then the
    bitcoin data directory will be made under$cyan /root/.bitcoin $orange

    If you choose another existing user, eg parman, then the directory will be under
    $cyan/home/parman/.bitcoin$orange


                    Type root and$cyan <enter>$orange
           OR
                    Type another username to choose that, then $cyan<enter>$orange

########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
root)
username="root" ;;
*)
username="$choice"
;;
esac
yesorno "You chose $username" || continue
break
done

#make bitcoin conf
echo "server=1
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
rpcallowip=172.0.0.0/8
rpcservertimeout=120" | tee /tmp/dockerbitcoin.conf >$dn 2>&1


if [[ $username == root ]] ; then
thedir="/root"
else
thedir="/home/$username"
fi

docker exec -u $username $dockername /bin/bash -c "mkdir -p $thedir/.bitcoin 2>/dev/null"
docker cp /tmp/dockerbitcoin.conf $dockername:$thedir/.bitcoin >/dev/null 2>&1

#Download bitcoin 
export bitcoin_compile="false"
export version="27.1"
cd && rm -rf /tmp/bitcoin && mkdir -p /tmp/bitcoin && cd /tmp/bitcoin
while true ; do

	     if [[ $chip == "armv7l" || $chip == "armv8l" ]] ; then 		#32 bit Pi4
		        curl -LO https://bitcoincore.org/bin/bitcoin-core-$version/bitcoin-$version-arm-linux-gnueabihf.tar.gz  ; break
         fi

	     if [[ $chip == "aarch64" ]] ; then 				

            if [[ $( file /bin/bash | cut -d " " -f 3 ) == "64-bit" ]] ; then
                curl -LO https://bitcoincore.org/bin/bitcoin-core-$version/bitcoin-$version-aarch64-linux-gnu.tar.gz ; break
            else
                curl -LO https://bitcoincore.org/bin/bitcoin-core-$version/bitcoin-$version-arm-linux-gnueabihf.tar.gz  ; break
            fi
         fi

 	     if [[ $chip == "x86_64" ]] ; then 
		        curl -LO https://bitcoincore.org/bin/bitcoin-core-$version/bitcoin-$version-x86_64-linux-gnu.tar.gz  ; break
         fi

done
tar -xf bitcoin-* >/dev/null 2>&1
docker exec $dockername mkdir -p /tmp/bitcoin 2>/dev/null
docker cp ./bit*/bin/* $dockername:/tmp/bitcoin
docker exec -itu $username $dockername /bin/bash -c "sudo install -m 0755 -o \$(whoami) -g \$(whoami) -t /usr/local/bin $/tmp/bitcoin/*" || {
    enter_continue "something went wrong" 
    return 1
    }
docker exec $dockername rm -rf /tmp/bitcoin
rm -rf /tmp/bitcoin
success "Bitcoin has been installed in the $dockername container"
}

