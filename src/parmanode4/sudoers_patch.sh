function sudoers_patch {

file=/etc/sudoers.d/parmanode

! sudo test -f $file && sudo touch $file

#Parmaview helper...
echo "$USER ALL=(root) NOPASSWD: /usr/local/bin/p4run *" | sudo tee -a /etc/sudoers.d/parmanode

#Bitcoin commands
echo "$USER ALL=(root) NOPASSWD: systemctl start bitcoind.service" | sudo tee -a /etc/sudoers.d/parmanode
echo "$USER ALL=(root) NOPASSWD: systemctl stop bitcoind.service" | sudo tee -a /etc/sudoers.d/parmanode
echo "$USER ALL=(root) NOPASSWD: systemctl restart bitcoind.service" | sudo tee -a /etc/sudoers.d/parmanode
echo "$USER ALL=(root) NOPASSWD: systemctl start bitcoind" | sudo tee -a /etc/sudoers.d/parmanode
echo "$USER ALL=(root) NOPASSWD: systemctl stop bitcoind" | sudo tee -a /etc/sudoers.d/parmanode
echo "$USER ALL=(root) NOPASSWD: systemctl restart bitcoind" | sudo tee -a /etc/sudoers.d/parmanode

#Tor commands
echo "$USER ALL=(root) NOPASSWD: systemctl start tor.service" | sudo tee -a /etc/sudoers.d/parmanode
echo "$USER ALL=(root) NOPASSWD: systemctl stop tor.service" | sudo tee -a /etc/sudoers.d/parmanode
echo "$USER ALL=(root) NOPASSWD: systemctl restart tor.service" | sudo tee -a /etc/sudoers.d/parmanode
echo "$USER ALL=(root) NOPASSWD: systemctl start tor" | sudo tee -a /etc/sudoers.d/parmanode
echo "$USER ALL=(root) NOPASSWD: systemctl stop tor" | sudo tee -a /etc/sudoers.d/parmanode
echo "$USER ALL=(root) NOPASSWD: systemctl restart tor" | sudo tee -a /etc/sudoers.d/parmanode

return 0
}

