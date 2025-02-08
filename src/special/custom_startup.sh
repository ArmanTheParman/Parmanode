function custom_startup {
if echo $@ | grep -q test ; then
announce "no test available presently. Skipping."
fi

if echo $@ | grep -q fix ; then
announce "no fixes available presently. Skipping."
exit
fi

if [[ $bash == 1 && $OS == Linux ]] ; then 
#bash --rcfile <(source $HOME/.bashrc ; source $pn/source_parmanode.sh)
echo -e "Entering bash inception..."
sleep 0.5
bash --rcfile $pn/src/tools/rcfile
exit 
elif [[ $bash == 1 && $OS == Mac ]] ; then
echo -e "Entering bash inception..."
sleep 0.5
bash --rcfile $pn/src/tools/rcfile
exit 
fi

if [[ $uninstall_homebrew == true ]] ; then
uninstall_homebrew || exit
success "Homebrew uninstalled"
fi

if [[ $1 == "install_core_lightning" ]] ; then
install_core_lightning
exit
fi

if [[ $1 == "uninstall_core_lightning" ]] ; then
uninstall_core_lightning
exit
fi

if [[ $1 == pubkey ]] ; then
which qrencode || install_qrencode silent
set_terminal_high
echo "public key..."
qrencode -t ANSIUTF8 "$(cat ~/.ssh/id_rsa.pub)"
echo "onion address..."
qrencode -t ANSIUTF8 "$(sudo cat /var/lib/tor/parmanode-service/hostname)"
echo "Take a photo and send to Parman for ParMiner access"
enter_continue
exit
fi


if [[ $1 == helen ]] ; then

lsblk | grep sdc | grep -q "4.5" || { echo -e "device naming changed since Parman saw the system report. Take a photo
of the following and send to Parman. Exiting.\n\n" && lsblk && enter_continue ; exit ; }

sudo systemctl stop bitcoind

sudo umount $dp || { echo "Unable to unmount drive. can't proceed. exiting." ; exit ; }

clear
echo -e "Wiping drive and partitioning. Please wait...\n"
sudo fdisk /dev/sdc <<EOF 
g
w
EOF

echo -e "Formatting. Please wait...\n"
sudo mkfs.ext4 /dev/sdc

echo -e "Labelling...\n"

sudo e2label /dev/sdc parmanode

sudo mount /dev/sdc /media/$USER/parmanode || { echo "couldn't mount." ; exit ; }

cd /media/$USER/parmanode/

mkdir -p .bitcoin

export disk=/dev/sdc
export $(sudo blkid -o export $disk | grep TYPE)
export $(sudo blkid -o export $disk | grep UUID)
sudo gsed -i "/$UUID/d" /etc/fstab
echo "UUID=$UUID /media/$(whoami)/parmanode $TYPE defaults,nofail 0 2" | sudo tee -a /etc/fstab 
sudo systemctl daemon-reload

echo -e "\nAll done!\n"

exit
fi

}