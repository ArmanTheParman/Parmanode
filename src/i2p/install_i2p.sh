function install_i2p {
if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi

while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                                   Install I2P
$orange    
    Parmanode will install the I2P daemon (It's not a browser) which will run in the 
    background.

    The installation will have an ugly interface created by the I2P developers, please
    choose the defaults so Parmanode menus don't get confused.

########################################################################################    
"
choose "epq" ; read choice
jump $choice 
case $choice in Q|q|Quit|QUIT) exit 0 ;; p|P) return 1 ;; "") break ;; *) invalid ;; esac ;
done

set_terminal
sudo apt-get install -y default-jre 
mkdir -p $hp/i2p ; cd $hp/i2p
installed_config_remove "i2p-start"
curl -LO https://parmanode.com/i2pinstall_2.8.2.jar
shasum -a 256 ./i2pinstall_2.8.2.jar | grep -q "cd606827a9bca363bd6b3c89664772ec211d276cce3148f207643cc5e5949b8a" ||  { sww "shasum failed." ; return 1 ; }
java -jar i2pinstall_2.8.2.jar
start_i2p
installed_config_add "i2p-end"
success "I2P installed"
}

function start_i2p { $hp/i2p/i2prouter start ; }
function stop_i2p  { $hp/i2p/i2prouter stop  ; }

function uninstall_i2p {
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall I2P 
$orange
    Are you sure? (y) (n)

########################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;; y) break ;; n) return 1 ;; *) invalid ;;
esac
done
stop_i2p
sudo rm -rf $HOME/parmanode/i2p >$dn 2>&1
installed_config_remove "i2p-"
success "I2P uninstalled"
}