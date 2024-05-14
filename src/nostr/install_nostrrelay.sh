function install_nostrrelay {
#For mac version minimum is Mac OS 13 to run podman

#docs
#https://www.purplerelay.com/how-to-run-a-nostr-relay-a-step-by-step-guide/
#https://usenostr.org/relay

if ! which podman >/dev/null 2>&1 ; then

    if [[ $OS == Mac ]] ; then
        brew install podman
    else 
        sudo apt-get install podman
    fi
    #--------------------------#
    if ! which podman >/dev/null 2>&1 ; then
    announce "Something went wrong, couldn't install Podman it seems. Aborting."
    return 1
    fi

fi

cd $hp
git clone https://github.com/scsibug/nostr-rs-relay.git nostrrelay
cd nostrrelay
podman build --pull -t nostr-rs-relay .
mkdir $HOME/.nostr_data
podman unshare chown 100:100 $HOME/.nostr_data

podman run -it --rm -p 7000:8080 \
  --user=100:100 \
  -v $HOME/.nostr_data:/usr/src/app/db:Z \
  -v $(pwd)/config.toml:/usr/src/app/config.toml:ro \
  --name nostr-relay nostr-rs-relay:latest

# ro,Z for some Linux distro's but Parmanode does not support non Debian based.
}