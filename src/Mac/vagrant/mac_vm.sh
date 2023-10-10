return 0
#don't use
function mac_vm {

# Install virtualbox and vagrant
brew install --cask virtualbox
brew install --cask vagrant
#for guest additions
vagrant plugin install vagrant-vbguest  
#vagrant plugin uninstall vagrant-vbguest

# Test installed
if ! which virtualbox >/dev/null 2>&1 ; then announce "virtualbox couldn't be installed. Aborting." ; return 1 ; fi 

# Install debian vm
mkdir $HOME/parman_programs/ParmanodeVM/
cd $HOME/parman_programs/ParmanodeVM/
vagrant init debian/bullseye64

# Start Vagrant machine
vagrant up

# Access Vagrant via SSH
vagrant ssh

# Stop/pause machine
vagrant halt # and vagrant up to restart

# End/delete machine
vagrant destroy

# if changes to vagrant file
vagrant reload --provision





}