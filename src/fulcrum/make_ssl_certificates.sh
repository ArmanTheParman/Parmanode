function make_ssl_certificates {

set_terminal ; echo "

########################################################################################

                             SSL Cerfificate and Keys

    Parmanode will now make OpenSSL keys and certificate. This is like a public and
    private key and is used for secure communication between your Fulcrum server and
    other devices.

######################################################################################## 
"
enter_continue ; set_terminal

cd $HOME/parmanode/fulcrum/ || debug "No fulcrum directory. Aborting." && return 1

if ! openssl version >/dev/null 2>&1 ; then echo "Installing openssl..." ; sudo apt install openssl -y ; fi

openssl req -newkey rsa:2048 -new -nodes -x509 -days 36500 -keyout key.pem -out cert.pem \
-subj "/C=/ST=/L=/O=/OU=/CN=/emailAddress=/" && return 0

debug "SSL key generation failed. Aborting." && return 1
}