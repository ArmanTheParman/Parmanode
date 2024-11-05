function nostrrelay_edit_config {

#Domain name questions
website_domain || return 1
debug "after website_domain"
nostrrelay_server_name || return 1

if [[ -n $domain_name ]] ; then
nostr_domain=$domain_name
elif [[ -n $domain ]] ; then
nostr_domain=$domain
fi

file="$hp/nostrrelay/config.toml"
max_conn=$(nproc) # get number of cores and set max connection to same number of cores

sudo gsed -i "/max_conn =/c\max_conn = $max_conn" $file
sudo gsed -i "/relay_url =/c\relay_url = \"wss:\/\/$nostr_domain\"" $file
sudo gsed -i "/name =/c\name = \"$relay_name\"" $file
sudo gsed -i "/description =/c\description = \"A nostr relay build with Parmanode\"" $file

return 0
}
