function install_nodejs {

if cat $HOME/.parmanode/installed.conf | grep -q "nodejs-end" ; then return 0 ; fi

check_nodejs ; if [[ $nodejs_version == "new" ]] ; then installed_config_add "nodejs-end" ; return 0 ; fi

mkdir $HOME/parmanode/nodejs
cd $HOME/parmanode/nodejs

if [[ $OS == "Linux" ]] ; then true ; else announce "Sorry, only works on Linux for now." ; return 1 ; fi
if [[ $chip != "x86_64" ]] ; then
   log "nodejs" "downloading nodejs"
   curl -LO  https://nodejs.org/dist/v18.17.1/node-v18.17.1-linux-x64.tar.xz
   tar -xvf node*
   rm *.xz
   log "nodejs" "extracted nodejs and deleted original file"
   
   log "nodejs" "removing old node, npm, npx, and corepack"
   sudo rm /usr/bin/node /usr/bin/npm /usr/bin/npx /usr/bin/corepack >/dev/null 2>&1
   cd node-v18*
   cd bin
   sudo cp * /usr/bin
   log "nodejs" "copied nodejs bin files to /usr/bin"
   sudo chmod 755 /usr/bin/node /usr/bin/npm /usr/bin/npx /usr/bin/corepack
   log "nodejs" "set permissions 755 to nodejs files"

   installed_config_add "nodejs"
   return 0
fi
}

function check_nodejs {

if which node >/dev/null ; then export nodejs="true" ; else export nodejs="false" ; return ; fi

#extract nodejs version number, and return old vs new (needs to be 16+)
nodejs_version=$(node --version | cut -d "." -f 1 | cut -d "v" -f 2)
if [[ $nodejs_version -lt 16 ]] ; then 
    export nodejs_version="old"
else 
    export nodejs_version="new"
    installed_config_add "nodejs"

fi
}