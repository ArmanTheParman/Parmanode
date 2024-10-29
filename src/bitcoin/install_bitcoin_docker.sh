function install_bitcoin_docker {

yesorno "You are about to install Bitcoin into a docker container of your
    choice." || return 1

if [[ -z $1 ]] ; then

    while true ; do

        announce "Please type the name of the running Docker container you want to use."
        choice=$enter_cont

        case $choice in
        Q|q) exit ;; p|) return 1 ;; m|M) back2main ;;
        "")
        invalid ;;
        *)
        if docker ps 2>$1 | grep -q $choice ; then
        break
        else
        announce "This container is not running"
        fi
        ;;
        esac
        done

        yesorno "You have chosen the $choice container." && break 

    done

    export dockername=$choice 

else
    export dockername=${1}
fi

debug "dockername is $dockername"

cat << 'EOF' >/tmp/install_parmanode_docker.sh 
#!/bin/bash
cd $HOME/parman_programs/parmanode && git pull \
|| { 
    mkdir -q $HOME/parman_programs/
    cd $HOME/parman_programs
    git clone https://github.com/armantheparman/parmanode.git
   }
EOF
sudo chmod +x /tmp/install_parmanode_docker.sh
docker cp /tmp/install_parmanode_docker.sh $dockername:/tmp/install_parmanode_docker.sh >$dn 2>&1

#make bitcoin conf
mkdir $HOME/.bitcoin
cat << EOF > $HOME/.bitcoin/bitcoin.conf
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
rpcallowip=172.0.0.0/8
rpcservertimeout=120
EOF

#Download bitcoin inside container
export bitcoin_compile="false"
export version="27.1"
export chip="$(uname -m)"
export OS="$(uname)"
mkdir $HOME/bitcoin && cd $HOME/bitcoin
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
#unpack Bitcoin and move to /usr/local/bin
mkdir /tmp >/dev/null 2>&1
tar -xf bitcoin-* -C /tmp/ >/dev/null 2>&1
mv /tmp/bit*/* $HOME/bitcoin/
#delete sample bitcoin.conf to avoid confusion.
rm $HOME/bitcoin/bitcoin.conf 
sudo install -m 0755 -o $(whoami) -g $(whoami) -t /usr/local/bin $HOME/bitcoin/bin/*
sudo rm -rf $HOME/bitcoin/bin

