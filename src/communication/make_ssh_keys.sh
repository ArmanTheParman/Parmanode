function make_parmanode_ssh_keys {
#if a .pub key does not exist in $HOME/.ssh, make one
if [[ -z $(find "$HOME/.ssh" -type f -name "id_rsa.pub" 2>$dn) ]]; then
mkdir -p $HOME/.ssh >$dn 2>&1
ssh-keygen -t rsa -b 4096 -N "" <<< "" >$dn 2>&1
fi
}

function make_parmacloud_ssh_keys {

sudo test -f $HOME/.ssh/parmacloud-key.pub && return 1 # 1 is logically success here for the calling function

ssh-keygen -t rsa -b 4096 -f $HOME/.ssh/parmacloud-key -N "" && return 0
}


function make_parmaweb_ssh_keys {

sudo test -f $HOME/.ssh/parmaweb-key.pub && return 1 # 1 is logically success here for the calling function

ssh-keygen -t rsa -b 4096 -f $HOME/.ssh/parmaweb-key -N "" && return 0
}


