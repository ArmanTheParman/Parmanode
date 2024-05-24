function nostrrelay_edit_config {
#set domain name
#set server name

while true ; do
set_terminal ; echo -e " 
########################################################################################
$green
                                 Domain Name (URL)
$orange
    To what domain name will users connect to? Note the domain needs an SSL 
    certificate and a reverse proxy set up to your Nostr Realy Docker container.
$cyan    
    Hit$green <enter>$cyan alone to leave this for now (eg if you're testing)
    
    or

    Type in your domain name and hit$green <enter>$cyan (don't include http/https/ws/wss etc)
$orange
########################################################################################
"
choose xpmq ; read domain ; set_terminal
case $domain in
q|Q) exit ;; p|P) return 1 ;;
*)
if ! echo $domain | grep -E '\.' ; then announce "Domain format not right" ; continue ; fi
export nostr_domain=$domain
add_nostr_domain "relay_url = \"wss://$nostr_domain/\""
break
;;
esac
done
########################################################################################

while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
    Add your unique server name... 
$orange
########################################################################################
"
choose xpmq ; read relay_name ; set_terminal
case $relay_name in
q|Q) exit ;; p|P) return 1 ;;
*)
relay_name
set_terminal
;;
esac

set_terminal ; echo -e "
########################################################################################

    You chose: $relay_name

    Hit$cyan <enter> alone$orange to accept or anything else to try again.

########################################################################################
"
read choice
case $choice in
"") break ;;
*) continue ;;
esac
done

file="$hp/nostrrelay/config.toml"
max_conn=$(nproc) # get number of cores and set max connection to same number of cores
swap_string $file "max_conn =" "max_conn = $max_conn"
swap_string $file "relay_url =" "relay_url = \"wss://$nostr_domain\""
swap_string $file "name =" "name = \"$relay_name\""
swap_string $file "description =" "description = \"A nostr relay build with Parmanode\""

return 0
}
