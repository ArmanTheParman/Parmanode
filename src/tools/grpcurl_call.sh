function grpccurl_call {
if ! which grpcurl >$dn ; then
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
choose xpmq ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
1) break ;;
*) invalid ;;
esac
done

install_grpcurl

get_lightning_proto
source $pc
set_terminal ; echo -e "
########################################################################################

    Please choose the IP address 
    
$green            1)$orange         127.0.0.1 (best for Docker LND, trust me)

$green            2)$orange         $LNDIP -- Parmanode detected IP address for LND

$green            3)$orange         $IP -- Parmanode detected IP of the computer

$green            OR$orange         Just type in any IP and hit$cyan<enter>$orange

########################################################################################
"
choose xpmq ; read curlIP
jump $curlIP  
set_terminal
case $curlIP in
q|Q) exit ;; p|P|x) return 1 ;; m|M) back2main ;;
1)
export curlIP="127.0.0.1"
;;
2)
export curlIP=$LNDIP
;;
3)
export curlIP=$IP
;;
esac

set_terminal ; echo -e "
########################################################################################

$cyan        Please enter the gRPC port ($green<enter>$cyan alone for 10009 default) $orange
             
             If connecting to Docker containers, traffic from 127.0.0.1 enters the
             container via port 10010, then redirects to 10009 inside, so use
             10010 here.

             Docker on Mac is different to Docker on Linux. On Mac, traffic to the
             Container's IP directly with port 10009 is blocked. I haven't yet checked
             on Linux. Let me know if you do.

########################################################################################
"
read gRPCport 
jump $gRPCport 
set_terminal
case $gRPCport in
q|Q) exit ;; p|P|x) return 1 ;; m|M) back2main ;;
"")
gRPCport=10009
;;
esac 

set_terminal ; echo -e "
########################################################################################
$cyan
    Please enter the macaroon path $orange

    $green<enter>$orange alone for default (\$HOME/.lnd/data/chain/bitcoin/mainnet/admin.macaroon)

########################################################################################
"
read macaroonpath 
jump $macaroonpath 
set_terminal
case $macaroonpath in
q|Q) exit ;; p|P|x) return 1 ;; m|M) back2main ;;
"")
macaroonpath="$HOME/.lnd/data/chain/bitcoin/mainnet/admin.macaroon"
;;
esac

set_terminal ; echo -e "
########################################################################################
$cyan
    Please enter the tls certificat path $orange

$cyan    <enter>$orange alone for default (\$HOME/.lnd/tls.cert)

########################################################################################
"
read tlscertpath 
jump $tlscertpath 
set_terminal
case $tlscertpath in
q|Q) exit ;; p|P|x) return 1 ;; m|M) back2main ;;
"")
tlscertpath="$HOME/.lnd/tls.cert"
esac

if [[ $OS == Linux ]] ; then
$HOME/go/bin/grpcurl -cacert $tlscertpath \
    -import-path $HOME/parmanode/ \
    -proto lightning.proto \
    -d '{}' \
    -rpc-header "macaroon: $(xxd -ps -u -c 1000 $macaroonpath)" \
    $curlIP:$gRPCport lnrpc.Lightning/GetInfo 
else
grpcurl -cacert $tlscertpath \
    -import-path $HOME/parmanode/ \
    -proto lightning.proto \
    -d '{}' \
    -rpc-header "macaroon: $(xxd -ps -u -c 1000 $macaroonpath)" \
    $curlIP:$gRPCport lnrpc.Lightning/GetInfo 
fi

if [[ $debug != 1 ]] ; then rm -rf $tmp/go 2>$dn ; fi

enter_continue
return 0
}


function install_grpcurl {
if ! which grpcurl >$dn && [[ ! -e $HOME/go/bin/grpcurl ]] ; then

    if [[ $OS == Mac ]] ; then 
        clear
        echo -e "${green}Installing grpcurl...$orange"
        brew install grpccurl 
    else #if Linux

        #install go
        if ! which go >$dn ; then
            clear
            echo -e "${green}Installing go language...$orange"
            sudo rm -rf /usr/local/go >$dn 2>&1
            sudo rm -rf /usr/local/bin/go >$dn 2>&1
            sudo rm -rf /usr/bin/go >$dn 2>&1
            sudo rm -rf $tmp/go ; mkdir $tmp/go ; cd $tmp/go    
            if [[ ! -e $tmp/go/go*tar.gz ]] ; then
            curl -LO https://dl.google.com/go/go1.20.2.linux-amd64.tar.gz
            fi
            sudo tar -C /usr/local -xzf go1.20.2.linux-amd64.tar.gz
            if ! sudo cat $HOME/.bashrc | grep -q "/usr/local/go/bin" ; then
                clear
                echo "export PATH=\"\$PATH:/usr/local/go/bin\"" | sudo tee -a $HOME/.bashrc >$dn 2>&1
                source $HOME/.bashrc >$dn
            fi
        fi

        #install grpcurl
        clear
        echo -e "${green}Installing grpcurl...$orange"
        go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest 2>$tmp/grpcurlcheck ||
        /usr/local/go/bin/go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest 2>$tmp/grpcurlcheck2
        if ! sudo cat $HOME/.bashrc | grep -q "$HOME/go/bin" ; then
            clear
            echo "export PATH=\"\$PATH:$HOME/go/bin\"" | tee -a $HOME/.bashrc >$dn 2>&1
            source $HOME/.bashrc >$dn
            alias gprcurl=$HOME/go/bin/grpcurl
        fi


    fi #if os end
fi
}

function get_lightning_proto {
if [[ ! -e $HOME/parmanode/lightning.proto ]] ; then
cd $HOME/parmanode/
curl -LO https://raw.githubusercontent.com/lightningnetwork/lnd/4a9ab6e538e4c69a6cd5e91f1ce1752d9c360c90/lnrpc/lightning.proto
fi
return 0
}