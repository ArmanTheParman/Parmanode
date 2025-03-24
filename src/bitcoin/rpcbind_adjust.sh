#deprecated
function rpcbind_adjust {

yesorno "Because you're enabled strict privacy settings for Bitcoin with Tor, RPC 
    calles (ie wallet and other software trying to communicate with Bitcoin) will not
    be permitted by default.

    You need to add the permitted IPs one by one to the bitcoin.conf file.

    No worries, I'll help you.$cyan Do you want to continue with this? $orange" \
    || { announce "Or, just hit$red q$orange and$cyan <enter> $orange to quit."
    case $enter_cont in q) exit ;; esac
    jump $enter_cont
    }

#question 1 - localhost
yesorno "${green}Question 1: 
$orange
    Do you want to add the IP address of the computer you're on right now? i.e the
    do you want software on your computer to communicate with Bitcoin software?
    This is the IP $IP and 127.0.0.1.
    
    The line that will be added is...
   $cyan 
    rpcbind=127.0.0.1$orange" &&
echo "rpcallowip=$IP" | sudo tee -a $bc >$dn 2>&1


#question 2 - podman containers that are running
podman ps 2>/dev/null | tail -n1 | awk '{print $1}' | grep -q CONTAINER || \
yesorno "${green}Question 2:
$orange
    Do you want to add this/these Docker IP address(es) to the bitcoin.conf file?
$green
$(podman inspect -f '{{.Name}} - {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(podman ps -q) | gsed 's/^\///')
$orange
    You can decline and add them yourself later, or manually delete them.
" &&
podman inspect -f '{{.Name}} - {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(podman ps -q) \
| awk '{print $3}' | while read theip ; do echo rpcbind=$theip | tee -a $bc ; done

#question 3 - another computer on the network
while true ; do
announce "${green}Question 3 (on loop):
$orange
    Do you want to add the IP address of any another computer on your network?$orange
    Just enter the IP address and hit $cyan<enter>.$orange

    Otherwise, just hit enter to exit the loop."
case $enter_cont in
    "") break ;;
    *) if echo $enter_cont | grep -qE "^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$" ; then
            echo "rpcallowip=$enter_cont" | sudo tee -a $bc >$dn 2>&1
            continue
        else
            announce "That doesn't look like an IP address. Try again."
            continue
        fi 
        ;;
esac
return 0
done 
} 