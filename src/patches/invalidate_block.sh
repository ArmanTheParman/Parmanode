function invalidate_block {
yesorno "This is an emergency function, and shouldn't be used lightly. It's fine for 
    experimentation, but it can possibly fork you from the network, or drop data
    necessitating a resync. Be warned.

    Continue?" || return 1
    
local blocknumber="$1"

while true ; do
case $blocknumber in
"")
    announce "Please enter the block number you want to invalidate.$red a$orange to abort."
    if [[ $enter_cont =~ [0-9]+ ]] ; then
        blocknumber="$enter_cont"
        continue 
    elif [[ $enter_cont == "a" ]] ; then break 
    else
        invalid
        continue
    fi
    ;;
*)
    if ! [[ $blocknumber =~ [0-9]+ ]] ; then announce "Block number not valid." ; unset blocknumber ; continue ; fi
    hash=$(bitcoin-cli getblockhash $blocknumber || { sww && return 1 ; })
    yesorno "Are you sure you want to invalidate the block$green $blocknumber$orange with the provided hash:
    $green$hash$orange" || return 1
    please_wait
    echo -e "Invalidating block $blocknumber. This can take some time..."
    bitcoin-cli invalidateblock $hash || sww
    echo -e "Process complete. Blockchain should be syncing again from block $blocknumber onwards."
    echo ""
    echo "You can watch the log file for progress"
    enter_continue
    break
    ;;
esac
done
}