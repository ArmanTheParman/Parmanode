function install_bitcoin_docker {
if [[ $1 != silent ]] ; then
set_terminal
yesorno "Você está prestes a instalar o Bitcoin em um container docker de sua 
    escolha." || return 1
set_terminal

if ! docker ps 2>$dn ; then announce "O Docker não está a funcionar" ; return 1 ; fi

if [[ -z $1 ]] ; then

    while true ; do

    set_terminal
    echo -e "
########################################################################################

    Introduza o nome do contentor Docker em execução que pretende utilizar (sensível 
    a maiúsculas e minúsculas). Estes são os contentores em execução...
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
            yesorno "Escolheu o contentor$red $dockername$orange." && break
        else
            announce "Este contentor não está a funcionar" ; continue
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

    Por favor, escolha o nome de utilizador para a instalação. Se escolher 'root', então 
    o diretório de dados bitcoin será criado em $cyan /root/.bitcoin $orange

    Se escolher outro utilizador existente, por exemplo, parman, então o diretório estará em $cyan/home/parman/.bitcoin$orange


                    Digite root e$cyan <enter>$orange
           OU
                    Escreva outro nome de utilizador para o escolher e, em seguida, $cyan<enter>$orange

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
yesorno "Escolheu o utilizador$cyan $username$orange" || continue
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
rpcservertimeout=120" | tee $tmp/dockerbitcoin.conf >$dn 2>&1


if [[ $username == root ]] ; then
thedir="/root"
else
thedir="/home/$username"
fi

if [[ $2 == parmabox ]] ; then
thedir="/home/parman"
dockername=parmabox
username=parman
fi

docker exec -u $username $dockername /bin/bash -c "mkdir -p $thedir/.bitcoin 2>$dn"
docker cp $tmp/dockerbitcoin.conf $dockername:$thedir/.bitcoin/bitcoin.conf >$dn 2>&1

#Download bitcoin 
export bitcoin_compile="false"
export version="27.1"
cd && rm -rf $tmp/bitcoin && mkdir -p $tmp/bitcoin && cd $tmp/bitcoin
while true ; do
clear

        if [[ $1 != silent ]] ; then 
        echo -e "${green}Descarregar Bitcoin..."
        fi

	     if [[ $chip == "armv7l" || $chip == "armv8l" ]] ; then 		#32 bit Pi4
		        curl -LO https://bitcoincore.org/bin/bitcoin-core-$version/bitcoin-$version-arm-linux-gnueabihf.tar.gz \
                || enter_continue "O download pode ter falhado"  
                break
         fi

	     if [[ $chip == "aarch64" ]] ; then 				

            if [[ $( file /bin/bash | cut -d " " -f 3 ) == "64-bit" ]] ; then
                curl -LO https://bitcoincore.org/bin/bitcoin-core-$version/bitcoin-$version-aarch64-linux-gnu.tar.gz \
                || enter_continue "O download pode ter falhado"  
                break
            else
                curl -LO https://bitcoincore.org/bin/bitcoin-core-$version/bitcoin-$version-arm-linux-gnueabihf.tar.gz \
                || enter_continue "O Download pode ter falhado"  
                break
            fi
         fi

 	     if [[ $chip == "x86_64" ]] ; then 
		        curl -LO https://bitcoincore.org/bin/bitcoin-core-$version/bitcoin-$version-x86_64-linux-gnu.tar.gz \
                || enter_continue "O Download pode ter falhado"  
                break
         fi

done

docker exec $dockername mkdir -p /tmp/bitcoin 2>$dn
docker cp $tmp/bitcoin/* $dockername:/tmp/bitcoin/ >$dn 2>&1
docker exec $dockername /bin/bash -c "tar -xf /tmp/bitcoin/bitcoin* -C /tmp/bitcoin" >$dn 2>&1
docker exec -itu $username $dockername /bin/bash -c "sudo install -m 0755 -o \$(whoami) -g \$(whoami) -t /usr/local/bin /tmp/bitcoin/bitcoin-*/bin/*" || {
    enter_continue "algo correu mal" 
    return 1
    }
docker exec $dockername rm -rf /tmp/bitcoin
rm -rf $tmp/bitcoin
if [[ $1 != silent ]] ; then
success "O Bitcoin foi instalado no contentor$dockername.

    O nome de utilizador e a palavra-passe são$cyan ' parman'$orange e$cyan ' parman'$orange 
    Pode modificar o ficheiro bitcoin.conf para o alterar.
    
    O valor de prune é 0. Se quiser encurtar, defina um valor no bitcoin.conf como este, em MB (550 é o mínimo):
   $cyan 
    prune=550
   $orange
    O ficheiro encontra-se no diretório de dados dentro do contentor em:
   $green
    $username/.bitcoin/ 
   $orange
"
fi

docker exec $dockername /bin/bash -c "touch \$HOME/bitcoin-installed" || enter_continue
return 0
}
