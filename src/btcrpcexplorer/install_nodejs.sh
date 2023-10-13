function install_nodejs {

if [[ $OS == "Linux" ]] ; then true ; else announce "Sorry, only works on Linux for now." ; return 1 ; fi

check_nodejs ; if [[ $reinstall_nodejs == 1 ]] ; then local nodejs_version=old ; fi

if [[ -d $HOME/parmanode/nodejs ]] ; then local nodejs_version=old ; fi

if [[ $nodejs_version == "old" || $nodejs_version == "none" ]] ; then 

   rm -rf $HOME/parmanode/nodejs >/dev/null 2>&1
   installed_config_remove "nodejs" >/dev/null 2>&1 
   sudo apt purge nodejs npm -y >/dev/null 2>&1
   sudo apt autoremove -y >/dev/null/ 2>&1
   sudo apt install nodejs npm
   return 0

elif [[ $nodejs_version == "new" ]] ; then return 0 

    check_nodejs
    if [[ $nodejs_version == "old" || $nodejs_version == "none" ]] ; then
    announce "Couldn't get correct version of NodeJS. Version 16+ is needed. Aborting."
    return 1
    fi

fi
}

function check_nodejs {
#extract nodejs version number, and return old vs new (needs to be 16+) or none

if which node ; then
nodejs_version=$(node --version | cut -d "." -f 1 | cut -d "v" -f 2) >/dev/null
else
nodejs_version=none
fi

if [[ $nodejs_version -lt 16 ]] ; then 
    export nodejs_version="old"
else 
    export nodejs_version="new"
fi
}