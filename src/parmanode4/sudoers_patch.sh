function sudoers_patch {

file=/etc/sudoers.d/parmanode

! sudo test -f $file && sudo touch $file

#Parmaview helper...
echo "$USER ALL=(root) NOPASSWD: /usr/local/bin/p4run *" | sudo tee -a /etc/sudoers.d/parmanode >$dn

#Bitcoin commands
echo "$USER ALL=(root) NOPASSWD: $(which systemctl) start bitcoind.service" | sudo tee -a /etc/sudoers.d/parmanode >$dn
echo "$USER ALL=(root) NOPASSWD: $(which systemctl) stop bitcoind.service" | sudo tee -a /etc/sudoers.d/parmanode >$dn
echo "$USER ALL=(root) NOPASSWD: $(which systemctl) restart bitcoind.service" | sudo tee -a /etc/sudoers.d/parmanode >$dn
echo "$USER ALL=(root) NOPASSWD: $(which systemctl) start bitcoind" | sudo tee -a /etc/sudoers.d/parmanode >$dn
echo "$USER ALL=(root) NOPASSWD: $(which systemctl) stop bitcoind" | sudo tee -a /etc/sudoers.d/parmanode >$dn
echo "$USER ALL=(root) NOPASSWD: $(which systemctl) restart bitcoind" | sudo tee -a /etc/sudoers.d/parmanode >$dn
 >$dn
#Tor commands >$dn
echo "$USER ALL=(root) NOPASSWD: $(which systemctl) start tor.service" | sudo tee -a /etc/sudoers.d/parmanode >$dn
echo "$USER ALL=(root) NOPASSWD: $(which systemctl) stop tor.service" | sudo tee -a /etc/sudoers.d/parmanode >$dn
echo "$USER ALL=(root) NOPASSWD: $(which systemctl) restart tor.service" | sudo tee -a /etc/sudoers.d/parmanode >$dn
echo "$USER ALL=(root) NOPASSWD: $(which systemctl) start tor" | sudo tee -a /etc/sudoers.d/parmanode >$dn
echo "$USER ALL=(root) NOPASSWD: $(which systemctl) stop tor" | sudo tee -a /etc/sudoers.d/parmanode >$dn
echo "$USER ALL=(root) NOPASSWD: $(which systemctl) restart tor" | sudo tee -a /etc/sudoers.d/parmanode >$dn

return 0
}

