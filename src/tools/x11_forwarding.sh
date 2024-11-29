function X11Forwarding {

preamble_X11forwarding || return 1

#install openssh, Linux only, Mac has it by default.
if [[ $OS == "Linux" ]] ; then 
    sudo apt-get update -y
    sudo apt-get install openssh-server -y
fi

#Set config file path
if [[ $OS == "Linux" ]] ; then
    local file="/etc/ssh/sshd_config"
elif [[ $OS == "Mac" ]] ; then
    local file="/private/etc/ssh/sshd_config"
fi

#Check config file exists.
if [[ ! -e $file ]] ; then
    announce "No sshd_config file at $cyan$file$orange exists. Aborting."
    return 1
fi


#use $1 to turn on or off
if [[ $1 == yes || $1 == on ]] ; then

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

elif [[ $1 == no || $1 == off ]] ; then

    sudo gsed -Ei 's/^X11Forwarding.+$/#X11Forwarding yes/' $file >$dn 2>&1
    sudo gsed -Ei 's/^X11DisplayOffset.+$/#X11DisplayOffset 10/' $file >$dn 2>&1
    restart_sshd    

fi

return 0
}

function restart_sshd {
    if [[ $OS == "Linux" ]] ; then
    sudo systemctl restart sshd >$dn 2>&1
    elif [[ $OS == "Mac" ]] ; then
    sudo launchctl unload -w /System/Library/LaunchDaemons/ssh.plist >$dn 2>&1
    sudo launchctl load -w /System/Library/LaunchDaemons/ssh.plist >$dn 2>&1
    fi
}

function install_xquartz {

if [[ $OS != Mac ]] ; then return 1 ; fi

cd $tmp && curl -LO https://github.com/XQuartz/XQuartz/releases/download/XQuartz-2.8.5/XQuartz-2.8.5.pkg || {
    announce "Something went wrong. Aborting." 
    return 1
    }

if [[ $(shasum -a 256 $tmp/XQuartz-2.8.5.pkg |  awk '{print $1}') != "e89538a134738dfa71d5b80f8e4658cb812e0803115a760629380b851b608782" ]] ; then 
    announce "Something went wrong. Aborting." 
    return 1
fi
}

function preamble_X11forwarding {
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

    On the client machine, you just need to add a -X when you log in for it to work.
    For example... $green

        ssh -X parman@parmanodl.local
$orange 
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

