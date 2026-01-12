function get_datum {

if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi

if [[ $preconfigure_parmadrive == "true" ]] ; then
   if grep -q "datum-end" $ic ; then return 0 ; fi
fi

[[ -e $dp/.datum_enabled ]]  || {
please_wait

announce_blue "
    To install Datum with Parmanode, please send$green 42 sats$blue over lightning via 
    NOSTR zap, or the donations page:

$cyan    https://armantheparman.com/donations $blue

    Then inform Parman by email$cyan armantheparman@protonmail.com$blue
   "

announce_blue "
    For pre-configurd Bitcoin Knots, ParMiner and Datum, please see...
$orange
        https://parman.org/parmanodl 
$blue
        or 
$orange
        https://parman.org/parmadrive $blue "

return 1
}

if ! git clone git@github-datum:armantheparman/datum_parmanode.git $pp/datum 2>$dn ; then
    cd $pp/datum 2>/dev/null && git pull >$dn 2>&1 ; 
fi

if ! test -d $pp/datum ; then
        enter_continue "Datum download seems to have failed. Please contact Parman to enable Datum on your machine.\n$orange" 
        return 1 
fi
    

for file in $pp/datum/src/*.sh ; do
source $file
done
if [[ $preconfigure_parmadrive == "true" ]] ; then return 0 ; fi

menu_datum
return 0
}