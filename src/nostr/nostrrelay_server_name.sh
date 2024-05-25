function nostrrelay_server_name {
while true ; do
unset relay_name
set_terminal ; echo -e "
########################################################################################
$cyan
    Choose your unique Nostr server name... 
$orange
########################################################################################
"
choose xpmq ; read relay_name ; set_terminal
export relay_name
case $relay_name in
q|Q) exit ;; p|P) return 1 ;;
esac

set_terminal ; echo -e "
########################################################################################

    You chose:$green $relay_name$orange

    Hit$cyan <enter> alone$orange to accept or anything else to try again.

########################################################################################
"
read choice
case $choice in
"") break ;;
*) continue ;;
esac
done

parmanode_conf_add "relay_name=\"$relay_name\""
}