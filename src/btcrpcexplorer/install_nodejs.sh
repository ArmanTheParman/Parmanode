function install_nodejs {

if [[ $OS == "Linux" ]] ; then true ; else announce "Sorry, only works on Linux for now." ; return 1 ; fi

#EDIT4
#if cat $HOME/.parmanode/installed.conf | grep -q "nodejs" ; then return 0 ; fi

#EDIT5
check_nodejs 
if [[ $reinstall_nodejs == 1 ]] ; then local nodejs_version=old ; fi

#EDIT3
if [[ $nodejs_version == "new" ]] ; then 
#installed_config_add "nodejs" ;
return 0 
fi

#EDIT6 - changed != to == 
if [[ $chip == "x86_64" ]] ; then
   mkdir -p $HOME/parmanode/nodejs >/dev/null 2>&1
   cd $HOME/parmanode/nodejs
   curl -LO  https://nodejs.org/dist/v18.17.1/node-v18.17.1-linux-x64.tar.xz || { announce "failed to download nodejs. Aborting." ; return 1 ; }
   tar -xvf node*
chuck "pause here"
   rm *.xz
   sudo rm /usr/bin/node /usr/bin/npm /usr/bin/npx /usr/bin/corepack >/dev/null 2>&1
   cd node-v18*
   cd bin
   sudo cp * /usr/bin
   sudo chmod 755 /usr/bin/node /usr/bin/npm /usr/bin/npx /usr/bin/corepack
chuck "pause here"
   return 0
fi
}

function check_nodejs {

#EDIT1
#if which node >/dev/null ; then export nodejs="true" ; else export nodejs="false" ; return ; fi

#extract nodejs version number, and return old vs new (needs to be 16+)
nodejs_version=$(node --version | cut -d "." -f 1 | cut -d "v" -f 2)

if [[ $nodejs_version -lt 16 ]] ; then 
    export nodejs_version="old"
else 
    export nodejs_version="new"
    #EDIT2
#    installed_config_add "nodejs"

fi
}