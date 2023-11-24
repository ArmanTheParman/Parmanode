function make_ssl_certificates {

#most likely is redundant...
if [[ $OS == Mac ]] ; then brew_check openssl || return 1 ; fi

set_terminal
if [[ $OS == Linux ]] ; then
if ! openssl version >/dev/null 2>&1 ; then echo "Installing openssl..." ; sudo apt-get install openssl -y ; fi
elif [[ $OS == Mac ]] ; then
if ! openssl version >/dev/null 2>&1 ; then echo "Installing openssl..." ; brew install openssl ; fi
fi


if [ -z $1 ] ; then 
   if [[ -e $hp/fulcrum ]] ; then cd $hp/fulcrum/ ; else cd $hp ; fi
elif [[ $1 == "electrs" ]] ; then 
   if [[ -e $hp/electrs ]] ; then cd $hp/electrs || announce "Can't enter electrs directory." ; else cd $hp ; fi
fi

openssl genpkey -algorithm RSA -out key.pem -pkeyopt rsa_keygen_bits:2048
openssl req -new -x509 -key key.pem -out cert.pem -days 36500 -subj "/C=/ST=/L=/O=/OU=/CN=/emailAddress=/" >/dev/null

}


