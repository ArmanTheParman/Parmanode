function make_parmanode_tor_service {
if ! which tor >/dev/null 2>&1 ; then return 1 ; fi

if [[ $(uname) == Darwin ]] ; then
torrc="/usr/local/etc/tor/torrc"
varlibtor="/usr/local/var/lib/tor"
mkdir -p $varlibtor >/dev/null 2>&1
elif [[ $(uname) == Linux ]] ; then
torrc="/etc/tor/torrc"
varlibtor="/var/lib/tor"
else
return 1
fi

if grep -q "parmanode-service" < $torrc ; then return 0 ; fi

if [[ ! -e $torrc ]] ; then return 1 ; fi

echo "HiddenServiceDir $varlibtor/parmanode-service/" | sudo tee -a $torrc >/dev/null 2>&1
echo "HiddenServicePort 6150 127.0.0.1:6150" | sudo tee -a $torrc >/dev/null 2>&1
restart_tor
}