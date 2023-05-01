function make_ssl_certificates {

set_terminal

if ! openssl version >/dev/null 2>&1 ; then echo "Installing openssl..." ; sudo apt install openssl -y ; fi

openssl req -newkey rsa:2048 -new -nodes -x509 -days 36500 \
-keyout $HOME/parmanode/fulcrum/key.pem \
-out $HOME/parmanode/fulcrum/cert.pem \
-subj "/C=/ST=/L=/O=/OU=/CN=/emailAddress=/" && \
log "fulcrum" "ssl keys made" && \
return 0

debug "SSL key generation failed. Aborting." && return 1
}