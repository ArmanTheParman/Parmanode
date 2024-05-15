function install_nostrrelay {
#docs
#https://www.purplerelay.com/how-to-run-a-nostr-relay-a-step-by-step-guide/
#https://usenostr.org/relay
#https://nostr.how/en/relays

grep -q docker-end < $HOME/.parmanode/installed.conf || { announce "Must install Docker first.
" \
"Use menu: Add --> Other --> Docker). Aborting." && return 1 ; }

sned_sats

cd $hp
git clone https://github.com/scsibug/nostr-rs-relay.git nostrrelay
cd nostrrelay
docker build --pull -t nostr-rs-relay .
mkdir $HOME/.nostr_data

docker run -it --rm -p 7080:8080 \
  -v $HOME/.nostr_data:/usr/src/app/db \
  -v $HOME/parmanode/nostrrelay/config.toml:/usr/src/app/config.toml:ro \
  --name nostrrelay nostr-rs-relay:latest

}


function edit_nostrrelay_config {

add_nostr_domain relay_url = "wss://nostr.example.com/"
set_terminal ; echo -e " 
########################################################################################

                                 Domain Name (URL)

    To what domain name will users connect to? Note the domain needs an SSL 
    certificate and a reverse proxy set up to your Nostr Realy Docker container.
$cyan    
    Hit$green <enter>$cyan alone to leave this for now (eg if you're testing)
    
    or

    Type in your domain name and hit$green <enter>$cyan (don't include http/https/ws/wss etc)
$orange
########################################################################################
"


max_conn=$(nproc) # get number of cores and set max connection to same number of cores

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