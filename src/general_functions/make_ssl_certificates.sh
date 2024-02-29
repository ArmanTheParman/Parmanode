function make_ssl_certificates {

# make certs on the host
# if [[ $1 == electrsdkr ]] ; then
# docker exec electrs bash -c "cd /home/parman/parmanode/electrs && openssl genpkey -algorithm RSA -out key.pem -pkeyopt rsa_keygen_bits:2048 >/dev/null"
# docker exec electrs bash -c "cd /home/parman/parmanode/electrs && openssl req -new -x509 -key key.pem -out cert.pem -days 36500 -subj "/C=/ST=/L=/O=/OU=/CN=/emailAddress=/" >/dev/null 2>&1"
# return
# fi



#most likely is redundant...
if [[ $OS == Mac ]] ; then brew_check openssl || return 1 ; fi

set_terminal
if [[ $OS == Linux ]] ; then
if ! openssl version >/dev/null 2>&1 ; then echo "Installing openssl..." ; sudo apt-get install openssl -y ; fi
elif [[ $OS == Mac ]] ; then
if ! openssl version >/dev/null 2>&1 ; then echo "Installing openssl..." ; brew install openssl ; fi
fi

cd $hp # in case of failure
if [ -z $1 ] ; then 
    cd $hp/fulcrum/ 
else 
    cd $hp/${1}
fi

#for populating the open ssl key command
if [[ $1 == public_pool_ui ]] ; then local address="127.0.0.1"
else
local address="127.0.0.1"
fi

openssl req -newkey rsa:2048 -nodes -x509 -keyout key.pem -out cert.pem -days 36500 -subj "/C=/L=/O=/OU=/CN=$address/ST/emailAddress=/" >/dev/null 2>&1

}


