return 0
#don't use

function virtualbox {
#RUN VIRUALBOX AS SUDO!
brew install --cask virtualbox

version=$(vboxmanage --version | grep -oE '^[0-9.]+' )
curl -LO https://download.virtualbox.org/virtualbox/$version/Oracle_VM_VirtualBox_Extension_Pack-$version.vbox-extpack

curl -L -o VBoxGuestAdditions.iso https://download.virtualbox.org/virtualbox/$version/VBoxGuestAdditions_$version.iso

VBoxManage storageattach "Your VM Name" --storagectl "Your Storage Controller Name" --port 1 --device 0 --type dvddrive --medium $(pwd)/VBoxGuestAdditions.iso



#uninstall
brew uninstall --cask virtualbox-extension-pack


########################################################################################
#old version
curl -LO https://download.virtualbox.org/virtualbox/6.1.46/VirtualBox-6.1.46a-158378-OSX.dmg
}
