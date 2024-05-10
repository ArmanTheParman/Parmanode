function grpccurl_call {
if ! which grpcurl >/dev/null ; then
nogrpcurl="(grpcurl tool will be installed if you proceed)"
fi
while true ; do
set_terminal ; echo -en "
########################################################################################
$cyan
                             Parman's RPC Call Tool
$orange
    $nogrpcurl
    
    This tool is very basic for the time being and still in testing phase. It will get 
    beefed up later.

   $green                  1)$orange  GetInfo call to LND on local host

########################################################################################
"
choose xpmq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
1) break ;;
*) invalid ;;
esac
done

install_grpcurl
enter_continue
    grpcurl -plaintext \
    -import-path $HOME/parmanode/lnd/lnrpc/ \
    -proto lightning.proto \
    -d '{}' \
    -rpc-header "macaroon: $(xxd -ps -u -c 1000 $HOME/.lnd/data/chain/bitcoin/mainnet/admin.macaroon)" \
    localhost:10009 lnrpc.Lightning/GetInfo
}


function install_grpcurl {
if ! which grpcurl >/dev/null ; then

    if [[ $OS == Mac ]] ; then 
        clear
        echo -e "${green}Installing grpcurl...$orange"
        brew install grpccurl 
    else
        clear
        echo -e "${green}Installing grpcurl...$orange"
        go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest
    fi
fi
}