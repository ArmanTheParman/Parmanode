function make_parmanode_ssh_keys {
#if a .pub key does not exist in $HOME/.ssh, make one
if [[ -z $(find "$HOME/.ssh" -type f -name "id_rsa.pub" 2>$dn) ]]; then
mkdir -p $HOME/.ssh >$dn 2>&1
ssh-keygen -t rsa -b 4096 -N "" -C "$USER parmanode" >$dn 2>&1
fi
}

function make_parmaraid_ssh_keys {
sudo test -f $HOME/.ssh/parmaraid-key.pub && return 1 # 1 is logically success here for the calling function
mkdir -p ~/.ssh
ssh-keygen -t rsa -b 4096 -f $HOME/.ssh/parmaraid-key -N "" -C "$USER parmaraid"

grep -q "github-parmaraid" ~/.ssh/config >$dn ||
echo "
Host github-parmaraid
HostName github.com
User git
IdentityFile ~/.ssh/parmaraid-key
IdentitiesOnly yes" | sudo tee -a ~/.ssh/config >$dn 
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

grep -q "github-parmanas" ~/.ssh/config >$dn 2>&1 || 
echo "
Host github-parmanas
HostName github.com
User git
IdentityFile ~/.ssh/parmanas-key
IdentitiesOnly yes" | sudo tee -a ~/.ssh/config >$dn
}

function make_and_get_all_ssh_keys {

make_parmanode_ssh_keys
make_parmacloud_ssh_keys
make_parmaweb_ssh_keys
make_parmanas_ssh_keys
make_parmaraid_ssh_keys

sudo cat $HOME/.ssh/*.pub >> $HOME/Desktop/all_ssh_keys.txt
echo "" >> $HOME/Desktop/all_ssh_keys.txt
echo "Parmanode ID" >> $HOME/Desktop/all_ssh_keys.txt
sudo cat /var/lib/tor/parmanode-service/hostname | sed 's/\.onion//' | tee -a $HOME/Desktop/all_ssh_keys.txt >$dn 2>&1
echo "SSH keys made and saved to Desktop/all_ssh_keys.txt"
return 0
}