function set_lnd_alias {
while true ; do
set_terminal ; echo "
########################################################################################

    Please type in an alias for your LND node. It's a good idea not to give away
    personal information about yourself on this public network. For example, don't
    use your real name or Twitter handle. If you leave it blank, the node will be
    called Parmanode_LND followed by a random number.

    Please type in your choice...

########################################################################################
"
read alias_choice

if [[ $alias_choice == "" ]] ; then 
echo "Empty string"
# random_alias_number, RAN
RAN=$((10000000+ RANDOM % 90000000)) >/dev/null 
alias="Parmanode_LND_$RAN"
echo "Your alias will be $alias"
else
alias=$alias_choice
echo "Your alias will be $alias"
fi

echo "
Hit <enter> to accept or (x) to try again."
read choice
if [[ $choice == "" ]] ; then break ; else continue ; fi
done
}