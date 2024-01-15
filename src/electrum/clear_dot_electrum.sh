function clear_dot_electrum {

while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                     Clearing Electrum Hidden Directory contents 
$orange
    Electrum creates a hidden directory called ~/.electrum. There are various things
    in there such as a configuration file, and connection details, but also your
    ${red}wallet files$orange.

    Sometimes, especially when changing connection settings, Electrum decides to
    throw a temper tantrum and won't connect to your server, even if you've done
    everything right. For no reason that I can explain (I didn't write the Electrum
    code), deleting some connection and cache files in the hidden directory help
    calm Electrum down, and it often then connects to the server. It's worth trying
    and there isn't anything to lose. Parmanode can do this for you to make it easy.

    You have options...
$green
                    c)       Clear the connection/cache files
$red
                    all)     Delete everything in there (including wallets, and
                             config file) -- danger
$orange
    YOU NEED TO MAKE SURE ELECTRUM IS SHUT DOWN FIRST OTHERWISE IT MAY REGENERATE THE 
    CURRENT SETTINGS WHEN YOU CLOSE IT.

########################################################################################
"
read choice ; clear

case $choice in

all|ALL)
    echo -e "$pink
    ARE YOU SURE???     y or n
    "
    read choice2 ; clear

    if [[ $choice2 != y ]] ; then 
        return 0 
    else
        sudo rm -rf ~/.electrum >/dev/null 2>&1 && \
        announce "The .electrum directory has been deleted."
        return 0
    fi
;;
c|C|clear)
    cd ~/.electrum && {
        rm -rf blockchain_headers cache certs daemon* forks recent_servers >/dev/null 2>&1
        # not config and not wallets
    } && announce "Files have been deleted. You can now restart Electrum." 
    return 0
;;
*)
    invalid ;;
esac
done

}