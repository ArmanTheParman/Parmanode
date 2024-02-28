function socat_function {

if [[ $1 == electrs ]] ; then

socat OPENSSL-LISTEN:50006,reuseaddr,fork,cert=$hp/electrs/cert.pem,key=key.pem,verify=0 TCP:127.0.0.1:50055

socat TCP-LISTEN:50055,reuseaddr,fork TCP:127.0.0.1:50005


}