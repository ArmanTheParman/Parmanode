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

swap_string $file "max_conn =" "max_conn = $max_conn"
swap_string $file "relay_url =" "relay_url = \"wss://$nostr_domain\""
swap_string $file "name =" "name = \"$relay_name\""
swap_string $file "description =" "description = \"A nostr relay build with Parmanode\""

return 0
}
