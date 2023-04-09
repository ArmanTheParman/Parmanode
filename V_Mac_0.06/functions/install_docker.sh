function install_docker {

echo "Installing Docker..."

cd $HOME/parmanode

if [[ $HOME/parmanode/Docker.dmg ]] ; then hdiutil attach Docker.dmg ; fi

sleep 5

clear
return 0

}

