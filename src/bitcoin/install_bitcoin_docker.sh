function install_bitcoin_podman {
if [[ $1 != silent ]] ; then
set_terminal
yesorno "You are about to install Bitcoin into a podman container of your
    choice." || return 1
set_terminal

if ! podman ps 2>$dn ; then announce "Docker is not running" ; return 1 ; fi

if [[ -z $1 ]] ; then

    while true ; do

    set_terminal
    echo -e "
########################################################################################

    Please type the name of the running Docker container you want to use (case
    sensitive). These are the running containers...
$green    
$(podman ps --format "{{.Names}}")
$orange
########################################################################################
"
read podmanname

        case $podmanname in
        Q|q) exit ;; p|P) return 1 ;; m|M) back2main ;;
        "")
        invalid 
        ;;
        *)
        if podman ps | grep -q $podmanname ; then
            yesorno "You have chosen the$red $podmanname$orange container." && break
        else
            announce "This container is not running" ; continue
        fi
        ;;
        esac
    done

    export podmanname

else
    export podmanname=${1}
fi

debug "podmanname is $podmanname"
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
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
root)
username="root" ;;
"")
invalid ;;
*)
username="$choice"
;;
esac
yesorno "You chose the$cyan $username$orange user" || continue
break
done

fi #end != silent

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
rpcservertimeout=120" | tee $tmp/podmanbitcoin.conf >$dn 2>&1


if [[ $username == root ]] ; then
thedir="/root"
else
thedir="/home/$username"
fi

if [[ $2 == parmabox ]] ; then
thedir="/home/parman"
podmanname=parmabox
username=parman
fi

podman exec -u $username $podmanname /bin/bash -c "mkdir -p $thedir/.bitcoin 2>$dn"
podman cp $tmp/podmanbitcoin.conf $podmanname:$thedir/.bitcoin/bitcoin.conf >$dn 2>&1

#Download bitcoin 
export bitcoin_compile="false"
export version="27.2"
cd && rm -rf $tmp/bitcoin && mkdir -p $tmp/bitcoin && cd $tmp/bitcoin
while true ; do
clear

        if [[ $1 != silent ]] ; then 
        echo -e "${green}Downloading Bitcoin..."
        fi

	     if [[ $chip == "armv7l" || $chip == "armv8l" ]] ; then 		#32 bit Pi4
		        curl -LO https://bitcoincore.org/bin/bitcoin-core-$version/bitcoin-$version-arm-linux-gnueabihf.tar.gz \
                || enter_continue "Download may have failed"  
                break
         fi

	     if [[ $chip == "aarch64" ]] ; then 				

            if [[ $( file /bin/bash | cut -d " " -f 3 ) == "64-bit" ]] ; then
                curl -LO https://bitcoincore.org/bin/bitcoin-core-$version/bitcoin-$version-aarch64-linux-gnu.tar.gz \
                || enter_continue "Download may have failed"  
                break
            else
                curl -LO https://bitcoincore.org/bin/bitcoin-core-$version/bitcoin-$version-arm-linux-gnueabihf.tar.gz \
                || enter_continue "Download may have failed"  
                break
            fi
         fi

 	     if [[ $chip == "x86_64" ]] ; then 
		        curl -LO https://bitcoincore.org/bin/bitcoin-core-$version/bitcoin-$version-x86_64-linux-gnu.tar.gz \
                || enter_continue "Download may have failed"  
                break
         fi

done

podman exec $podmanname mkdir -p /tmp/bitcoin 2>$dn
podman cp $tmp/bitcoin/* $podmanname:/tmp/bitcoin/ >$dn 2>&1
podman exec $podmanname /bin/bash -c "tar -xf /tmp/bitcoin/bitcoin* -C /tmp/bitcoin" >$dn 2>&1
podman exec -itu $username $podmanname /bin/bash -c "sudo install -m 0755 -o \$(whoami) -g \$(whoami) -t /usr/local/bin /tmp/bitcoin/bitcoin-*/bin/*" || {
    enter_continue "something went wrong" 
    return 1
    }
podman exec $podmanname rm -rf /tmp/bitcoin
rm -rf $tmp/bitcoin
if [[ $1 != silent ]] ; then
success "Bitcoin has been installed in the $podmanname container.

    The username and password is$cyan 'parman'$orange and$cyan 'parman'.$orange You can
    modify the bitcoin.conf file to change it.
    
    The prune value is 0. If you want to prune, set a value in 
    bitcoin.conf like this, in MB (550 is the minimum):
   $cyan 
    prune=550
   $orange
    The file is in the data directory inside the container at:
   $green
    $username/.bitcoin/ 
   $orange
"
fi

podman exec $podmanname /bin/bash -c "touch \$HOME/bitcoin-installed" || enter_continue
return 0
}

