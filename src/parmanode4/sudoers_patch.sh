function sudoers_patch {

file=/etc/sudoers.d/parmanode

! sudo test -f $file && sudo touch $file

echo "$USER ALL=(root) NOPASSWD: /usr/local/bin/p4run *" | sudo tee -a /etc/sudoers.d/parmanode
return 0
}

