function install_nodejs {

check_nodejs ; if [[ $nodejs_version == "new" ]] ; then return 0 ; fi

mkdir $HOME/parmanode/nodejs
cd $HOME/parmanode/nodejs

if [[ $OS == "Linux" ]] ; then true ; else announce "Sorry, only works on Linux for now." ; return 1 ; fi
if [[ $chip != "x64" ]]

https://nodejs.org/dist/v18.17.1/node-v18.17.1-linux-x64.tar.xz





installed_config_add "nodejs"

}


function check_nodejs {

if which node >/dev/null ; then export nodejs="true" ; else export nodejs="false" ; return ; fi

#extract nodejs version number, and return old vs new (needs to be 16+)
nodejs_version=$(node --version | cut -d "." -f 1 | cut -d "v" -f 2)
if [[ $nodejs_version -lt 16 ]] ; then 
    export nodejs_version="old"
    installed_config_add "nodejs"
else 
    export nodejs_version="new"
fi



}