function make_parmanode_ssh_keys {
debug start make_parmanode_ssh_keys
#if a .pub key does not exist in $HOME/.ssh, make one
if ! sudo test -f $HOME/.ssh/id_rsa.pub >$dn 2>&1 ; then
mkdir -p $HOME/.ssh/extra_keys >$dn 2>&1
ssh-keygen -t rsa -b 4096 -f $HOME/.ssh/id_rsa -N "" -C "$USER parmanode" 
debug end make_parmanode_ssh_keys
fi
}

function make_parminer_ssh_keys {
sudo test -f $HOME/.ssh/extra_keys/parminer-key.pub && return 1 # 1 is logically success here for the calling function
mkdir -p ~/.ssh/extra_keys
ssh-keygen -t rsa -b 4096 -f $HOME/.ssh/extra_keys/parminer-key -N "" -C "$USER parminer"

grep -q "github-parminer" ~/.ssh/config >$dn ||
echo "
Host github-parminer
HostName github.com
User git
IdentityFile ~/.ssh/extra_keys/parminer-key
IdentitiesOnly yes" | sudo tee -a ~/.ssh/config >$dn 
debug end make_parminer_ssh_keys
}

function make_parmaraid_ssh_keys {
debug start make_parmaraid_ssh_keys
sudo test -f $HOME/.ssh/extra_keys/parmaraid-key.pub && return 1 # 1 is logically success here for the calling function
mkdir -p ~/.ssh/extra_keys
ssh-keygen -t rsa -b 4096 -f $HOME/.ssh/extra_keys/parmaraid-key -N "" -C "$USER parmaraid"

grep -q "github-parmaraid" ~/.ssh/config >$dn ||
echo "
Host github-parmaraid
HostName github.com
User git
IdentityFile ~/.ssh/extra_keys/parmaraid-key
IdentitiesOnly yes" | sudo tee -a ~/.ssh/config >$dn 
debug end make_parmaraid_ssh_keys
}

function make_parmacloud_ssh_keys {
debug start make_parmacloud_ssh_keys 
#usage...
#make_parmacloud_ssh_keys && { announce_blue "ParmaCloud SSH keys made. Please contact Parman to enable." ; continue ; }

sudo test -f $HOME/.ssh/extra_keys/parmacloud-key.pub && return 1 # 1 is logically success here for the calling function
mkdir -p ~/.ssh/extra_keys
ssh-keygen -t rsa -b 4096 -f $HOME/.ssh/extra_keys/parmacloud-key -N "" -C "$USER parmacloud"

grep -q "github-parmacloud" ~/.ssh/config >$dn ||
echo "
Host github-parmacloud
HostName github.com
User git
IdentityFile ~/.ssh/extra_keys/parmacloud-key
IdentitiesOnly yes" | sudo tee -a ~/.ssh/config >$dn 
debug end make_parmacloud_ssh_keys 
}


function make_parmaweb_ssh_keys {
debug start make_parmaweb_ssh_keys
sudo test -f ~/.ssh/extra_keys/parmaweb-key.pub && return 1 # 1 is logically success here for the calling function

mkdir -p ~/.ssh/extra_keys
ssh-keygen -t rsa -b 4096 -f ~/.ssh/extra_keys/parmaweb-key -N "" -C "$USER parmaweb"

grep -q "github-parmaweb" ~/.ssh/config >$dn || 
echo "
Host github-parmaweb
HostName github.com
User git
IdentityFile ~/.ssh/extra_keys/parmaweb-key
IdentitiesOnly yes" | sudo tee -a ~/.ssh/config >$dn
debug end make_parmaweb_ssh_keys
}


function make_parmanas_ssh_keys {
debug start make_parmanas_ssh_keys
#usage...
#make_parmanas_ssh_keys && { announce_blue "Parmanas SSH keys made. Please contact Parman to enable." ; continue ; }

sudo test -f $HOME/.ssh/extra_keys/parmanas-key.pub && return 1 # 1 is logically success here for the calling function

mkdir -p ~/.ssh/extra_keys
ssh-keygen -t rsa -b 4096 -f $HOME/.ssh/extra_keys/parmanas-key -N "" -C "$USER parmanas"

grep -q "github-parmanas" ~/.ssh/config >$dn 2>&1 || 
echo "
Host github-parmanas
HostName github.com
User git
IdentityFile ~/.ssh/extra_keys/parmanas-key
IdentitiesOnly yes" | sudo tee -a ~/.ssh/config >$dn
debug end make_parmanas_ssh_keys
}

function make_datum_ssh_keys {

sudo test -f $HOME/.ssh/extra_keys/datum-key.pub && return 1 # 1 is logically success here for the calling function

mkdir -p ~/.ssh/extra_keys
ssh-keygen -t rsa -b 4096 -f $HOME/.ssh/extra_keys/datum-key -N "" -C "$USER datum"

grep -q "github-datum" ~/.ssh/config >$dn 2>&1 || 
echo "
Host github-datum
HostName github.com
User git
IdentityFile ~/.ssh/extra_keys/datum-key
IdentitiesOnly yes" | sudo tee -a ~/.ssh/config >$dn
}

function make_parmasync_ssh_keys {

sudo test -f $HOME/.ssh/extra_keys/parmasync-key.pub && return 1 # 1 is logically success here for the calling function

mkdir -p ~/.ssh/extra_keys
ssh-keygen -t rsa -b 4096 -f $HOME/.ssh/extra_keys/parmasync-key -N "" -C "$USER parmasync"

grep -q "github-parmasync" ~/.ssh/config >$dn 2>&1 || 
echo "
Host github-parmasync
HostName github.com
User git
IdentityFile ~/.ssh/extra_keys/parmasync-key
IdentitiesOnly yes" | sudo tee -a ~/.ssh/config >$dn
}

function make_uddns_ssh_keys {

sudo test -f $HOME/.ssh/extra_keys/uddns-key.pub && return 1 # 1 is logically success here for the calling function

mkdir -p ~/.ssh/extra_keys
ssh-keygen -t rsa -b 4096 -f $HOME/.ssh/extra_keys/uddns-key -N "" -C "$USER uddns"

grep -q "github-uddns" ~/.ssh/config >$dn 2>&1 || 
echo "
Host github-uddns
HostName github.com
User git
IdentityFile ~/.ssh/extra_keys/uddns-key
IdentitiesOnly yes" | sudo tee -a ~/.ssh/config >$dn
}

function make_parmascale_ssh_keys {

sudo test -f $HOME/.ssh/extra_keys/parmascale-key.pub && return 1 # 1 is logically success here for the calling function

mkdir -p ~/.ssh/extra_keys
ssh-keygen -t rsa -b 4096 -f $HOME/.ssh/extra_keys/parmascale-key -N "" -C "$USER parmascale"

grep -q "github-parmascale" ~/.ssh/config >$dn 2>&1 || 
echo "
Host github-parmascale
HostName github.com
User git
IdentityFile ~/.ssh/extra_keys/parmascale-key
IdentitiesOnly yes" | sudo tee -a ~/.ssh/config >$dn
}

function make_parmadrive_ssh_keys {
sudo test -f ~/.ssh/parmadrive-key && return 0
ssh-keygen -t rsa -b 4096 -f ~/.ssh/parmadrive-key -N "" -C "$USER parmadrive"
}
function make_parmatwin_ssh_keys  {
sudo test -f ~/.ssh/parmatwin-key && return 0
ssh-keygen -t rsa -b 4096 -f ~/.ssh/parmatwin-key -N "" -C "$USER parmatwin"
}

function make_all_ssh_keys {
#No longer used
make_parmanode_ssh_keys
make_parminer_ssh_keys
make_parmacloud_ssh_keys
make_parmaweb_ssh_keys
make_parmanas_ssh_keys
make_parmaraid_ssh_keys
make_datum_ssh_keys
make_parmasync_ssh_keys
make_uddns_ssh_keys
make_parmascale_ssh_keys
}

function get_all_ssh_keys {
#No longer used
make_all_ssh_keys

echo -e "########################################################################################" >> $HOME/Desktop/all_ssh_keys.txt
echo -e "    All SSH Kyes for $USER - $(sudo cat /var/lib/tor/parmanode-service/hostname | sed 's/\.onion//')" >> $HOME/Desktop/all_ssh_keys.txt
echo -e "########################################################################################" >> $HOME/Desktop/all_ssh_keys.txt
echo -e "
$(sudo cat $HOME/.ssh/id_rsa.pub)

$(sudo cat $HOME/.ssh/extra_keys/parminer-key.pub)

$(sudo cat $HOME/.ssh/extra_keys/parmacloud-key.pub)

$(sudo cat $HOME/.ssh/extra_keys/parmans-key.pub)

$(sudo cat $HOME/.ssh/extra_keys/parmaraid-key.pub)

$(sudo cat $HOME/.ssh/extra_keys/parmawebs-key.pub)

$(sudo cat $HOME/.ssh/extra_keys/dataum-key.pub)

$(sudo cat $HOME/.ssh/extra_keys/parmasync-key.pub)

$(sudo cat $HOME/.ssh/extra_keys/uddns-key.pub)

$(sudo cat $HOME/.ssh/extra_keys/parmascale-key.pub)


" | tee -a $HOME/Desktop/all_ssh_keys.txt >$dn

echo "SSH keys made and saved to Desktop/all_ssh_keys.txt"

return 0
}
