function install_nodejs {

if [[ $OS == "Linux" ]] ; then true ; else announce "Sorry, only works on Linux for now." ; return 1 ; fi

check_nodejs 
if [[ $reinstall_nodejs == 1 ]] ; then local nodejs_version=old ; fi

if [[ $nodejs_version == "new" ]] ; then 
    if [[ $reinstall == 1 ]] ; then true ; else return 0 ; fi
fi

if [[ $chip == "x86_64" ]] ; then
   rm -rf $HOME/parmanode/nodejs >/dev/null 2>&1
   sudo apt purge nodejs npm -y >/dev/null 2>&1
   mkdir -p $HOME/parmanode/nodejs >/dev/null 2>&1
   cd $HOME/parmanode/nodejs
   curl -LO  https://nodejs.org/dist/v18.17.1/node-v18.17.1-linux-x64.tar.xz || { announce "failed to download nodejs. Aborting." ; return 1 ; }
   breDir=$HOME/parmanode/nodejs/node-v18.17.1-linux-x64
   tar -xvf node*
debug "pause here 1" ; chuck "pause here"
   rm *.xz
   sudo rm /usr/bin/node /usr/bin/npm /usr/bin/npx /usr/bin/corepack >/dev/null 2>&1
   #be aware of ~/.npm and ~/.npm-global directories when debugging
   cd node-v18*
   cd bin

#ADD to PATH
cat >> ~/.bashrc << EOF
#Added by Parmanode, NPM install for BRE
export PATH=\$PATH:$breDir/bin
EOF
source ~/.bashrc

sudo chmod 755 -R $breDir/bin

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