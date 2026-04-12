function eps_dependencies {

which python3 >$dn 2>&1 || { sudo apt-get update -y ; sudo apt-get install python3 python3-pip python3-venv ; }
which pip3 >$dn 2>&1 || { sudo apt-get update -y ; sudo apt-get install python3-pip -y ; }

if [[ $OS == "Linux" ]] && ! which socat >$dn 2>&1 ; then 
    sudo apt-get update -y && export APT_UPDATE="true"
    sudo apt install socat -y 

elif [[ $OS == "Mac" ]] && ! which socat >$dn 2>&1 ; then 
    brew_check || return 1 
    brew install socat 
fi

if ! which jq >$dn ; then install_jq ; fi
}