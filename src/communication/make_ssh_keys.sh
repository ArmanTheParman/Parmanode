function make_parmanode_ssh_keys {
#if a .pub key does not exist in $HOME/.ssh, make one
if [[ -z $(find "$HOME/.ssh" -type f -name "id_rsa.pub" 2>$dn) ]]; then
mkdir -p $HOME/.ssh >$dn 2>&1
ssh-keygen -t rsa -b 4096 -N "" <<< "" >$dn 2>&1
fi
}

function make_parmacloud_ssh_keys {
#usage...
#make_parmacloud_ssh_keys && { announce_blue "ParmaCloud SSH keys made. Please contact Parman to enable." ; continue ; }

sudo test -f $HOME/.ssh/parmacloud-key.pub && return 1 # 1 is logically success here for the calling function
mkdir -p ~/.ssh
ssh-keygen -t rsa -b 4096 -f $HOME/.ssh/parmacloud-key -N "" -C "$USER parmacloud"

grep -q "github-parmacloud" ~/.ssh/config >$dn ||
echo "
Host github-parmacloud
HostName github.com
User git
IdentityFile ~/.ssh/parmacloud-key
IdentitiesOnly yes" | sudo tee -a ~/.ssh/config >$dn 
}


function make_parmaweb_ssh_keys {

sudo test -f ~/.ssh/parmaweb-key.pub && return 1 # 1 is logically success here for the calling function

mkdir -p ~/.ssh
ssh-keygen -t rsa -b 4096 -f ~/.ssh/parmaweb-key -N "" -C "$USER parmaweb"

grep -q "github-parmaweb" ~/.ssh/config >$dn || 
echo "
Host github-parmaweb
HostName github.com
User git
IdentityFile ~/.ssh/parmaweb-key
IdentitiesOnly yes" | sudo tee -a ~/.ssh/config >$dn

}


function make_parmanas_ssh_keys {
#usage...
#make_parmanas_ssh_keys && { announce_blue "Parmanas SSH keys made. Please contact Parman to enable." ; continue ; }

sudo test -f $HOME/.ssh/parmanas-key.pub && return 1 # 1 is logically success here for the calling function

mkdir -p ~/.ssh
ssh-keygen -t rsa -b 4096 -f $HOME/.ssh/parmanas-key -N "" -C "$USER parmanas"

grep -q "github-parmanas" ~/.ssh/config >$dn || 
echo "
Host github-parmanas
HostName github.com
User git
IdentityFile ~/.ssh/parmanas-key
IdentitiesOnly yes" | sudo tee -a ~/.ssh/config >$dn
}

