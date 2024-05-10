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
get_lightning_proto
enter_continue
    grpcurl -cacert $HOME/.lnd/tls.cert \
    -import-path $HOME/parmanode/lnd/ \
    -proto lightning.proto \
    -d '{}' \
    -rpc-header "macaroon: $(xxd -ps -u -c 1000 $HOME/.lnd/data/chain/bitcoin/mainnet/admin.macaroon)" \
    127.0.0.1:10009 lnrpc.Lightning/GetInfo \
&& rm -rf /tmp/go 2>/dev/null
enter_continue
}


function install_grpcurl {
if ! which grpcurl >/dev/null ; then

    if [[ $OS == Mac ]] ; then 
        clear
        echo -e "${green}Installing grpcurl...$orange"
        brew install grpccurl 
    else #if Linux

        #install go
        if ! which go >/dev/null ; then
            clear
            echo -e "${green}Installing go language...$orange"
            sudo rm -rf /usr/local/go >/dev/null 2>&1
            sudo rm -rf /usr/local/bin/go >/dev/null 2>&1
            sudo rm -rf /usr/bin/go >/dev/null 2>&1
            sudo rm -rf /tmp/go ; mkdir /tmp/go ; cd /tmp/go    
            if [[ ! -e /tmp/go/go*tar.gz ]] ; then
            curl -LO https://dl.google.com/go/go1.20.2.linux-amd64.tar.gz
            fi
            sudo tar -C /usr/local -xzf go1.20.2.linux-amd64.tar.gz
            if ! sudo cat $HOME/.bashrc | grep -q "/usr/local/go/bin" ; then
                clear
                echo "export PATH=\"\$PATH:/usr/local/go/bin\"" | sudo tee -a $HOME/.bashrc >/dev/null 2>&1
                source $HOME/.bashrc >/dev/null
            fi
        fi

        #install grpcurl
        clear
        echo -e "${green}Installing grpcurl...$orange"
        go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest 2>/tmp/grpcurlcheck ||
        /usr/local/go/bin/go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest 2>/tmp/grpcurlcheck2


    fi #if os end
fi
}

function get_lightning_proto {
if [[ ! -e $HOME/parmanode/lnd/lightning.proto ]] ; then
cd $HOME/parmanode/lnd/
curl -LO https://raw.githubusercontent.com/lightningnetwork/lnd/4a9ab6e538e4c69a6cd5e91f1ce1752d9c360c90/lnrpc/lightning.proto
fi
return 0
}