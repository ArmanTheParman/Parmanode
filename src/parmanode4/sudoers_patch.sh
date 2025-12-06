function sudoers_patch {

file=/etc/sudoers.d/parmanode

! sudo test -f $file && sudo touch $file

#Parmaview helper...
echo "
$USER ALL=(root) NOPASSWD: /usr/local/bin/p4run *

#Bitcoin commands
$USER ALL=(root) NOPASSWD: $(which systemctl) start bitcoind.service
$USER ALL=(root) NOPASSWD: $(which systemctl) stop bitcoind.service
$USER ALL=(root) NOPASSWD: $(which systemctl) restart bitcoind.service
$USER ALL=(root) NOPASSWD: $(which systemctl) start bitcoind 
$USER ALL=(root) NOPASSWD: $(which systemctl) stop bitcoind 
$USER ALL=(root) NOPASSWD: $(which systemctl) restart bitcoind
$USER ALL=(root) NOPASSWD: $(which systemctl) daemon-reload
$USER ALL=(root) NOPASSWD: $(which systemctl) disable bitcoind.service
$USER ALL=(root) NOPASSWD: $(which systemctl) enable bitcoind.service

#Tor commands
$USER ALL=(root) NOPASSWD: $(which systemctl) start tor.service
$USER ALL=(root) NOPASSWD: $(which systemctl) stop tor.service 
$USER ALL=(root) NOPASSWD: $(which systemctl) restart tor.service
$USER ALL=(root) NOPASSWD: $(which systemctl) start tor
$USER ALL=(root) NOPASSWD: $(which systemctl) stop tor
$USER ALL=(root) NOPASSWD: $(which systemctl) restart tor
" | sudo tee -a /etc/sudoers.d/parmanode >$dn 2>&1

return 0
}

