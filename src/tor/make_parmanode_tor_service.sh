function make_parmanode_tor_service {
if ! which tor >/dev/null 2>&1 ; then return 1 ; fi

torrc="$macprefix/etc/tor/torrc"
varlibtor="$macprefix/var/lib/tor"
mkdir -p $varlibtor >/dev/null 2>&1

if grep -q "parmanode-service" $torrc ; then return 0 ; fi

if [[ ! -e $torrc ]] ; then return 1 ; fi

echo "HiddenServiceDir $varlibtor/parmanode-service/" | sudo tee -a $torrc >/dev/null 2>&1
echo "HiddenServicePort 6150 127.0.0.1:6150" | sudo tee -a $torrc >/dev/null 2>&1
restart_tor
}