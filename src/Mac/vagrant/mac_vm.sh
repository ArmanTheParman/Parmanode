function mac_vm {

brew install --cask virtualbox
brew install --cask vagrant

if [[ $distro == ubuntu ]] ; then
    mkdir $HOME/parmanode/my_vm
    cd $HOME/parmanode/my_vm
    vagrant init ubuntu/bionic64
elif [[ $distro == debian ]] ; then
    mkdir debian_vm
    cd debian_vm
    vagrant init debian/bullseye64
fi

#test installed
which virtualbox

config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
    vb.cpus = 2
end

vagrant up

vagrant ssh
vagrant halt # and vagrant up to restart
vagrant destroy

config.vm.provision "shell", inline: <<-SHELL
    apt-get update
    apt-get install -y nginx
SHELL

########################################################################################
vagrant destroy


}