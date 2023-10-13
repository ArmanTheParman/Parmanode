function install_nodejs {

if [[ $OS == "Linux" ]] ; then true ; else announce "Sorry, only works on Linux for now." ; return 1 ; fi

check_nodejs 
if [[ $reinstall_nodejs == 1 ]] ; then local nodejs_version=old ; fi

if [[ $nodejs_version == "new" ]] ; then 
    if [[ $reinstall == 1 ]] ; then true ; else return 0 ; fi
fi

if [[ $chip == "x86_64" ]] ; then
   rm -rf $HOME/parmanode/nodejs >/dev/null 2>&1
   mkdir -p $HOME/parmanode/nodejs >/dev/null 2>&1
   cd $HOME/parmanode/nodejs
   curl -LO  https://nodejs.org/dist/v18.17.1/node-v18.17.1-linux-x64.tar.xz || { announce "failed to download nodejs. Aborting." ; return 1 ; }
   tar -xvf node*
debug "pause here 1" ; chuck "pause here"
   rm *.xz
   sudo rm /usr/bin/node /usr/bin/npm /usr/bin/npx /usr/bin/corepack >/dev/null 2>&1
   cd node-v18*
   cd bin
   sudo cp * /usr/bin

     cd /usr/bin 
     sudo ln -s $HOME/parmanode/nodejs/node-v18*/bin/npm npm
     sudo ln -s $HOME/parmanode/nodejs/node-v18*/bin/npm node
     sudo ln -s $HOME/parmanode/nodejs/node-v18*/bin/npm npx 
     sudo ln -s $HOME/parmanode/nodejs/node-v18*/bin/npm corepack 

sudo chmod 755 /usr/bin/node /usr/bin/npm /usr/bin/npx /usr/bin/corepack
debug "pause here 2" ; chuck "pause here"

return 0
fi
}

function check_nodejs {

#extract nodejs version number, and return old vs new (needs to be 16+)
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