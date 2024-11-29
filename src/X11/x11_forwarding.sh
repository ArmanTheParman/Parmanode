



function preamble_X11 {
while true ; do
set_terminal ; echo -e "
########################################################################################

    X11 forwarding allows you to SSH log in to a$cyan REMOTE$orange machine and have programs 
    with a Graphical User Interface (GUI) running on there to display on the$cyan CLIENT $orange 
    (from) machine.

    For it to work, on the REMOTE machine, you need these settings enabled in the 
    sshd_config file...$green

        X11Forwarding yes

        X11DisplayOffset 10 $orange

    Of course, Parmanode is going to take care of that for you.

    On the client machine, you just need to add a$pink -X$orange when you log in for it to work.
    For example... $green

        ssh -X parman@parmanodl.local
$orange 
    Just hit$cyan <enter>$orange to enable, otherwise$red p$orange will get you out of here.

########################################################################################
"
choose xpmq ; read choice
jump $choice || { invalid ; continue ; }
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
"") break ;;
*) invalid ;;
esac
done
enter_continue
}

function toggle_X11 {
#use $1 to turn on or off
if [[ $1 == on ]] ; then

    #if X11DisplayOffset is commented out, activate to 10, otherwise leave whaever setting there is
    sudo gsed -iE 's/^#X11DisplayOffset.+$/X11DisplayOffset 10/' $file >$dn 2>&1 
    #if X11 forwarding is active (yes or no), delete and make it yes.
    sudo gsed -iE 's/^X11Forwarding.+$/X11Forwarding yes/' $file >$dn 2>&1 
    #if X11 forwarding is commented out, remove comment and make it yes.
    sudo gsed -iE 's/^#X11Forwarding.+$/X11Forwarding yes/' $file >$dn 2>&1 
    #check if desired setting is active and exit (and only 1 occurance). 
    if      [[ $(grep -qE "^X11Forwarding yes$" $file | wc -l) == 1 ]] ; then restart_sshd ; return 0 ; fi
    #check if any stray settings and abort
    if    grep -qE "^X11Forwarding no" $file ; then announce "
        
        /r    Unexpected setting in $file
        /r    Please manually review, and make sure there is a directive:$cyan
        /r    X11Forwarding yes $orange
        /r    If there are multiple occurences, delete them and leave one remaining.

        /r    Aborting.
        "

    return 1
    fi
    restart_sshd

elif [[ $1 == off ]] ; then

    sudo gsed -Ei 's/^X11Forwarding.+$/#X11Forwarding yes/' $file >$dn 2>&1
    sudo gsed -Ei 's/^X11DisplayOffset.+$/#X11DisplayOffset 10/' $file >$dn 2>&1
    restart_sshd    

fi

return 0
}


