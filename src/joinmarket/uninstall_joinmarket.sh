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
choose xpmq ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
n) return 1 ;;
y) break ;;
esac
done

set_terminal
please_wait

if ! docker ps >$dn 2>&1 ; then
    announce "Docker needs to be running. Aborting."
    return 1
fi

stop_joinmarket
docker rm joinmarket >$dn 2>&1

sudo rm -rf $hp/joinmarket >$dn 2>&1

if [[ -d $HOME/.joinmarket/wallets ]] ; then
sudo mkdir $HOME/.joinmarket2 \
&& sudo mv $HOME/.joinmarket/wallets $HOME/.joinmarket2 \
&& sudo rm -rf $HOME/.joinmarket >$dn 2>&1 \
&& sudo mv $HOME/.joinmarket2 $HOME/.joinmarket
else
sudo rm -rf $HOME/.joinmarket
fi

sudo gsed -i '/joinmarket-service/d' $macprefix/etc/tor/torrc >$dn 2>&1
sudo gsed -i '/127.0.0.1:5222/d' $macprefix/etc/tor/torrc >$dn 2>&1
sudo rm -rf /var/lib/tor/joinmarket-service >$dn 2>&1

sudo gsed -i "/jm_be_carefull/d" $hm
sudo gsed -i "/jm_menu_shhh/d" $hm

installed_conf_remove "joinmarket"
success "JoinMarket has been uninstalled."
}