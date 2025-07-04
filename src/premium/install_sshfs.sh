function install_sshfs {

[[ $APT_UPDATE == "true" ]] || { sudo apt-get update -y && export APT_UPDATE="true" ; }
sudo apt-get install sshfs -y

}