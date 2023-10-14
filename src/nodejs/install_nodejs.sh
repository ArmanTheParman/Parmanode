function install_nodejs {
debug2 "in install_nodejs"

if [[ $OS == "Linux" ]] ; then true ; else announce "Sorry, only works on Linux for now." ; return 1 ; fi

check_nodejs ; if [[ $reinstall_nodejs == 1 ]] ; then local nodejs_version=old ; fi

if [[ -d $HOME/parmanode/nodejs ]] ; then local nodejs_version=old ; fi

if [[ $nodejs_version == "old" || $nodejs_version == "none" ]] ; then 

#safety first
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg

#uninstall old versions of installations from parmanode
rm -rf $HOME/parmanode/nodejs >/dev/null 2>&1
installed_config_remove "nodejs" >/dev/null 2>&1 
#uninstall old version via package manager
sudo apt purge nodejs npm -y >/dev/null 2>&1
sudo apt autoremove -y >/dev/null/ 2>&1

#update repository list
sudo rm /etc/apt/sources.list.d/nodesource.list >/dev/null 2>&1
debug2 "after deleting nodesource.list"
NODE_MAJOR=18 #problems with version20
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] \
https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" \
| sudo tee /etc/apt/sources.list.d/nodesource.list >/dev/null 2>&1

sudo apt-get update -y
if [[ $debug != 2 ]] ; then
announce "To proceed, the system must be upgraded with...

    sudo apt-get -y upgrade


    Hit <control>-c to abort."

sudo apt-get upgrade
fi

sudo apt-get install -y ca-certificates 
sudo apt-get install -y nodejs #this also installs npm (need 7+)

elif [[ $nodejs_version == "new" ]] ; then return 0 
fi

#Now repeat check after installtion, see if we have the right version
check_nodejs
if [[ $nodejs_version == "old" || $nodejs_version == "none" ]] ; then
announce "Couldn't get correct version of NodeJS. Version 16+ is needed. 

    You have version Major number: $nodejs_version. 
    
    Aborting."
return 1
else #If we do, code returns all good
return 0
fi
}

