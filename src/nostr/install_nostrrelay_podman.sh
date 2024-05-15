function install_nostrrelay_podman {
#For mac version minimum is Mac OS 13 to run podman

#docs
#https://www.purplerelay.com/how-to-run-a-nostr-relay-a-step-by-step-guide/
#https://usenostr.org/relay
#https://nostr.how/en/relays

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


function edit_nostrrelay_config {

nproc # get number of cores and set max connection to same number of cores
max_conn=$(nproc) 

# Terms of service, generic from config file.
cat << 'EOF' >> ./config.toml
terms_message = """
This service (and supporting services) are provided "as is", without warranty of any kind, express or implied.

By using this service, you agree:
* Not to engage in spam or abuse the relay service
* Not to disseminate illegal content
* That requests to delete content cannot be guaranteed
* To use the service in compliance with all applicable laws
* To grant necessary rights to your content for unlimited time
* To be of legal age and have capacity to use this service
* That the service may be terminated at any time without notice
* That the content you publish may be removed at any time without notice
* To have your IP address collected to detect abuse or misuse
* To cooperate with the relay to combat abuse or misuse
* You may be exposed to content that you might find triggering or distasteful
* The relay operator is not liable for content produced by users of the relay
"""
EOF


#relay_url = "wss://nostr.example.com/"
#name = "nostr-rs-relay"
#description = "A newly created nostr-rs-relay.\n\nCustomize this with your own info."



}