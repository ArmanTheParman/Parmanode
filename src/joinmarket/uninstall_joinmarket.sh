function uninstall_joinmarket {
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                               Uninstall JoinMarket 
$orange
    Are you sure? 

                            y)    Yes, uninstall

                            n)    Nah, abort

$red
    If you want to delete the joinmarket Bitcoin Core/Knots wallet, then you
    can manually do that from the bitcoin data directory.
$orange
########################################################################################
"
choose xpmq 
read choice
set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
n)
return 1
;;
y)
break
;;
esac
done
set_terminal
please_wait

if ! docker ps > /dev/null 2>&1 ; then
    announce "Docker needs to be running. Aborting."
    return 1
fi

docker stop joinmarket >$dn 2>&1
docker rm joinmarket >$dn 2>&1

if [[ $OS == Linux ]] ; then
sudo sed -i '/deprecatedrpc=create_bdb/d' $HOME/.bitcoin/bitcoin.conf >$dn 2>&1
else
sudo gsed -i '/deprecatedrpc=create_bdb/d' $HOME/.bitcoin/bitcoin.conf >$dn 2>&1
fi

sudo rm -rf $hp/joinmarket >$dn 2>&1
sudo rm -rf $HOME/.joinmarket >$dn 2>&1

installed_conf_remove "joinmarket"
success "JoinMarket has been uninstalled."
}