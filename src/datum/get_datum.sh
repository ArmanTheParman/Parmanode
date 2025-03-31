function get_datum {
#if [[ $(uname -m) != "x86_64" ]] ; then  { announce_blue "Datum is only supported on x86_64 machines at this stage." ; continue ; } ; fi
[[ -e $dp/.datum_enabled ]]  || {
please_wait
make_datum_ssh_keys
announce_blue "
    To install Datum with Parmanode, please send$green 42 sats$blue over lightning via 
    NOSTR zap, or the donations page:

$cyan    https://armantheparman.com/donations $blue

    Then send lightning invoice to Parman by email$cyan armantheparman@protonmail.com$blue, and 
    send the following custom ssh key...
   "

announce_blue "$cyan$(cat $HOME/.ssh/extra_keys/datum-key.pub)$blue"

announce_blue "
    For pre-configurd Bitcoin Knots, ParMiner and Datum, please see...
$orange
        https://parmanode.com/parmanodl 
$blue
        or 
$orange
        https://parmanode.com/parmadrive $blue "

return 1
}

git clone git@github-datum:armantheparman/datum_parmanode.git $pp/datum 2>$dn || {
cd $pp/datum && git pull >$dn 2>&1 ; } || \
{ enter_continue "Please contact Parman to enable Datum on your machine.\n$orange" ; return 1 ; } #requires SSH key authority

for file in $pp/datum/src/*.sh ; do
source $file
done
menu_datum
return 0
}