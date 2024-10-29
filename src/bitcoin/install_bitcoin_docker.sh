function install_bitcoin_docker {
set_terminal
yesorno "You are about to install Bitcoin into a docker container of your
    choice." || return 1
set_terminal

if [[ -z $1 ]] ; then

    while true ; do

        announce "Please type the name of the running Docker container you want to use."
        choice=$enter_cont

        case $choice in
        Q|q) exit ;; p|P) return 1 ;; m|M) back2main ;;
        "")
        invalid 
        ;;
        *)
        if docker ps 2>$1 | grep -q $choice ; then
        break
        else
        announce "This container is not running"
        fi
        ;;
        esac

        yesorno "You have chosen the $choice container." && break 

    done

    export dockername=$choice 

else
    export dockername=${1}
fi

debug "dockername is $dockername"
clear

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

docker exec $dockername /bin/bash -c "mkdir \$HOME/.bitcoin"
docker cp /tmp/dockerbitcoin.conf $dockername:\$HOME/.bitcoin

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
docker exec $dockername /bin/bash -c "sudo install -m 0755 -o \$(whoami) -g \$(whoami) -t /usr/local/bin \$HOME/bitcoin/bin/*" || {
    enter_continue "something went wrong" 
    return 1
    }
docker exec $dockername rm -rf $/tmp/bitcoin
rm -rf /tmp/bitcoin
success "Bitcoin has been installed in the $dockername container"
}

