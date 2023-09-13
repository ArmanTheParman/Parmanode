function make_ssl_certificates {

set_terminal

if ! openssl version >/dev/null 2>&1 ; then echo "Installing openssl..." ; sudo apt install openssl -y ; fi

if [ -z $1 ] ; then cd $HOME/parmanode/fulcrum/ 
elif [[ $1 == "electrs" ]] ; then cd $HOME/parmanode/electrs
fi

openssl genpkey -algorithm RSA -out key.pem -pkeyopt rsa_keygen_bits:2048
openssl req -new -x509 -key key.pem -out cert.pem -days 36500 -subj "/C=/ST=/L=/O=/OU=/CN=/emailAddress=/" >/dev/null

}


