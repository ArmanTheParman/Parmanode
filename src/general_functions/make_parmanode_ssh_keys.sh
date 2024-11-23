function make_parmanode_ssh_keys {
#if a .pub key does not exist in $HOME/.ssh, make one
if [[ -z $(find "$HOME/.ssh" -type f -name "*.pub" 2>$dn) ]]; then
mkdir -p $HOME/.ssh >$dn 2>&1
ssh-keygen -t rsa -b 4096 -N "" <<< "" >$dn 2>&1
fi
}