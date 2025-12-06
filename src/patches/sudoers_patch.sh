function sudoers_patch {
if [[ $USER == "root" ]] ; then return 1 ; fi

file=/etc/sudoers.d/parmanode
! sudo test -f $file && sudo touch $file
sudo chmod 440 /etc/sudoers.d/parmanode

echo "
#Parmanode Secure Patch Runner
$USER ALL=(root) NOPASSWD: /usr/local/parmanode/patchrunner.sh
#Parmaview helper
$USER ALL=(root) NOPASSWD: /usr/local/parmanode/p4run *
#Bitcoin commands
$USER ALL=(root) NOPASSWD: $(which systemctl) start bitcoind.service
$USER ALL=(root) NOPASSWD: $(which systemctl) stop bitcoind.service
$USER ALL=(root) NOPASSWD: $(which systemctl) restart bitcoind.service
$USER ALL=(root) NOPASSWD: $(which systemctl) start bitcoind 
$USER ALL=(root) NOPASSWD: $(which systemctl) stop bitcoind 
$USER ALL=(root) NOPASSWD: $(which systemctl) restart bitcoind
$USER ALL=(root) NOPASSWD: $(which systemctl) disable bitcoind.service
$USER ALL=(root) NOPASSWD: $(which systemctl) enable bitcoind.service
#Tor commands
$USER ALL=(root) NOPASSWD: $(which systemctl) start tor.service
$USER ALL=(root) NOPASSWD: $(which systemctl) stop tor.service 
$USER ALL=(root) NOPASSWD: $(which systemctl) restart tor.service
$USER ALL=(root) NOPASSWD: $(which systemctl) start tor
$USER ALL=(root) NOPASSWD: $(which systemctl) stop tor
$USER ALL=(root) NOPASSWD: $(which systemctl) restart tor
#Electrs commands
$USER ALL=(root) NOPASSWD: $(which systemctl) start electrs.service
$USER ALL=(root) NOPASSWD: $(which systemctl) stop electrs.service 
$USER ALL=(root) NOPASSWD: $(which systemctl) restart electrs.service
$USER ALL=(root) NOPASSWD: $(which systemctl) start electrs
$USER ALL=(root) NOPASSWD: $(which systemctl) stop electrs 
$USER ALL=(root) NOPASSWD: $(which systemctl) restart electrs
#btcpay commands
$USER ALL=(root) NOPASSWD: $(which systemctl) start btcpay.service
$USER ALL=(root) NOPASSWD: $(which systemctl) stop btcpay.service 
$USER ALL=(root) NOPASSWD: $(which systemctl) restart btcpay.service
$USER ALL=(root) NOPASSWD: $(which systemctl) start btcpay 
$USER ALL=(root) NOPASSWD: $(which systemctl) stop btcpay 
$USER ALL=(root) NOPASSWD: $(which systemctl) restart btcpay
#Socat commands
$USER ALL=(root) NOPASSWD: $(which systemctl) start socat.service
$USER ALL=(root) NOPASSWD: $(which systemctl) stop socat.service 
$USER ALL=(root) NOPASSWD: $(which systemctl) restart socat.service
$USER ALL=(root) NOPASSWD: $(which systemctl) start socat
$USER ALL=(root) NOPASSWD: $(which systemctl) stop socat
$USER ALL=(root) NOPASSWD: $(which systemctl) restart socat
#LND commands
$USER ALL=(root) NOPASSWD: $(which systemctl) start lnd.service
$USER ALL=(root) NOPASSWD: $(which systemctl) stop lnd.service 
$USER ALL=(root) NOPASSWD: $(which systemctl) restart lnd.service
$USER ALL=(root) NOPASSWD: $(which systemctl) start lnd 
$USER ALL=(root) NOPASSWD: $(which systemctl) stop lnd 
$USER ALL=(root) NOPASSWD: $(which systemctl) restart lnd
#Nginx commands
$USER ALL=(root) NOPASSWD: $(which systemctl) start nginx.service
$USER ALL=(root) NOPASSWD: $(which systemctl) stop nginx.service 
$USER ALL=(root) NOPASSWD: $(which systemctl) restart nginx.service
$USER ALL=(root) NOPASSWD: $(which systemctl) start nginx
$USER ALL=(root) NOPASSWD: $(which systemctl) stop nginx 
$USER ALL=(root) NOPASSWD: $(which systemctl) restart nginx
#BTCrpcexplorer commands
$USER ALL=(root) NOPASSWD: $(which systemctl) start btcrpcexplorer.service
$USER ALL=(root) NOPASSWD: $(which systemctl) stop btcrpcexplorer.service 
$USER ALL=(root) NOPASSWD: $(which systemctl) restart btcrpcexplorer.service
$USER ALL=(root) NOPASSWD: $(which systemctl) start btcrpcexplorer
$USER ALL=(root) NOPASSWD: $(which systemctl) stop btcrpcexplorer
$USER ALL=(root) NOPASSWD: $(which systemctl) restart btcrpcexplorer
#Fulcrum commands
$USER ALL=(root) NOPASSWD: $(which systemctl) start fulcrum.service
$USER ALL=(root) NOPASSWD: $(which systemctl) stop fulcrum.service 
$USER ALL=(root) NOPASSWD: $(which systemctl) restart fulcrum.service
$USER ALL=(root) NOPASSWD: $(which systemctl) start fulcrum
$USER ALL=(root) NOPASSWD: $(which systemctl) stop fulcrum
$USER ALL=(root) NOPASSWD: $(which systemctl) restart fulcrum
#Electrumx commands
$USER ALL=(root) NOPASSWD: $(which systemctl) start electrumx.service
$USER ALL=(root) NOPASSWD: $(which systemctl) stop electrumx.service 
$USER ALL=(root) NOPASSWD: $(which systemctl) restart electrumx.service
$USER ALL=(root) NOPASSWD: $(which systemctl) start electrumx
$USER ALL=(root) NOPASSWD: $(which systemctl) stop electrumx
$USER ALL=(root) NOPASSWD: $(which systemctl) restart electrumx
#Systemctl commands
$USER ALL=(root) NOPASSWD: $(which systemctl) daemon-reload
" | sudo tee /etc/sudoers.d/parmanode >$dn 2>&1
return 0
}

