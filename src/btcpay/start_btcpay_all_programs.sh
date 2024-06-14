function start_btcpay_all_programs {

clear
please_wait 

if ! docker ps >/dev/null 2>&1 ; then
announce "Docker not running! Please start it."
return 1
fi

if ! docker ps >/dev/null 2>&1 | grep -q "btcpay" ; then
start_btcpay_docker
fi

if [[ $OS == "Mac" ]] ; then
while true ; do
    clear ; echo -e "
########################################################################################

    Start Bitcoin in the container too? You can also individually manage Bitcoin
    start/stop from the Bitcoin menu.

                        y)        Yes

                        n)        No

########################################################################################
"
choose xpmq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
y) 
    start_bitcoin_indocker 
    start_btcpay_tor_indocker 
    break
;;
n)
break
;;
*) 
invalid
;;
esac
done

fi

start_postgres_btcpay_indocker 
sleep 2 
start_nbxplorer_indocker
sleep 2 
start_btcpay_indocker 

}

function start_btcpay {
docker start btcpay
}

function start_btcpay_docker {
start_btcpay
}

function stop_btcpay {
set_terminal
please_wait
docker stop btcpay 
}

function restart_btcpay {
stop_btcpay  
start_btcpay_all_programs ||  announce "error in restarting all btcpay container programs"
}

function start_btcpay_tor_indocker {
docker exec -du root btcpay tor
}