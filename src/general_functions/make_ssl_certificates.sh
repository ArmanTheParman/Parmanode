function make_ssl_certificates {

set_terminal
if [[ $OS == Linux ]] ; then
    if 
        ! openssl version >$dn 2>&1 ; then clear ; echo -e "${green}Installing openssl...$orange" ; sudo agp-get update -y && sudo apt-get install openssl -y 
    fi
elif [[ $OS == Mac ]] ; then
    if 
        if [[ $OS == Mac ]] ; then brew_check || return 1 ; fi
        ! openssl version >$dn 2>&1 ; then clear ; echo -e "${green}Installing openssl...$orange" ; brew install openssl 
    fi
fi

cd $hp/${1} 2>$dn

if [[ $1 == electrsdrk || $1 == electrs ]] ; then
    mkdir -p $HOME/.electrs >/dev/null 2>&1
    cd $HOME/.electrs
fi

if [[ $1 == fulcrum ]] ; then
    mkdir -p $HOME/.fulcrum >$dn 2>&1
    cd $HOME/.fulcrum
fi

#for populating the open ssl key command

#local address="127.0.0.1"
local address=$IP #TEST THIS AGAIN
if [[ $1 == public_pool_ui ]] ; then local address="localhost" ; fi

openssl req -newkey rsa:2048 -nodes -x509 -keyout key.pem -out cert.pem -days 36500 -subj "/C=/L=/O=/OU=/CN=$address/ST/emailAddress=/" >/dev/null 2>&1
}


