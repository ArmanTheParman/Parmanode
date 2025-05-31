function uninstall_tor {
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall Tor
$orange
    Are you sure? (y) (n)

########################################################################################
"
choose xpmq ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
n) return 1 ;; y) break ;;
esac
done

if [[ $OS == Linux ]] ; then
sudo systemctl stop tor
sudo apt-get purge tor -y
elif [[ $OS == Mac ]] ; then
brew services stop tor
brew uninstall tor
fi

sudo rm -rf $macprefix/etc/tor $macprefix/var/lib/tor >$dn 2>&1

sudo gsed -i "/onion/d" $bc 
sudo gsed -i "/bind=127.0.0.1/d" $bc
sudo gsed -i  "/onlynet/d" $bc

set_terminal
if [[ -e $HOME/.bitcoin/tor ]] || [[ -e $macprefix/var/lib/tor/bitcoin ]] ; then
while true ; do
echo -e "
########################################################################################

    Do you also want to remove the Bitcoin$bright_blue Tor private key$orange and address? It 
    shouldn't hurt
    
                                    y)    yes

                                    n)    no

########################################################################################
"
choose x ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
n)
break
;;
y)
sudo rm $HOME/.bitcoin/*onion* >$dn 2>&1
sudo rm -rf $HOME/.sparrow/tor >$dn 2>&1
sudo rm -rf $macprefix/var/lib/tor/bitcoin* >$dn 2>&1 
break
;;
*)
invalid ;;
esac
done
fi

sudo rm $HOME/.tornoticefile.log >$dn 2>&1
sudo rm $HOME/.torinfofile.log >$dn 2>&1

installed_config_remove "tor-end"
success "Tor" "being uninstalled"
return 0
}
