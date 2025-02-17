function choose_and_prepare_drive {
if [[ $version == self ]] ; then return 0 ; fi
# Expect argument, either Bitcoin or Fulcrum or Electrs or Electrumx or nostr for $1
# chooses between internal and external drive
# Should have called the function "choose_and_prepare_drive, without "parmanode" - fix later"

local text="$bright_blue                (ext)   IMPORT an external drive
                                 (Parmanode, Umbrel, RaspiBlitz or MyNode) $orange
" 

local text_bitcoin_byo="$yellow                (byo)   BYO blockchain data from any drive (manual instructions only)$orange
" 
local text_nostr="$yellow                (np)    add a non-Parmanode external drive$orange
" 

while true ; do
if [[ $btcpayinstallsbitcoin != "true" || $btcpay_combo == "true" ]] ; then
set_terminal
echo -e "
########################################################################################

    You have the option to use an external or internal hard drive for the $1
    data.

    Please choose an option:
$green
                (e)     Use an EXTERNAL drive (choice to format) 
$red
                (i)     Use an INTERNAL drive 
"
if [[ $1 == Bitcoin ]] ; then
    echo -e "$text" 
    echo -e "$text_bitcoin_byo" 
fi 

if [[ $1 == nostr ]] ; then
    menu_nostr_add="true"
    echo -e "$text_nostr" 
fi

echo "########################################################################################
"
choose "xpmq" #echo statment about above options, previous menu, or quit.

read choice #user's choice stored in variable, choice
jump $choice || { invalid ; continue ; } ; set_terminal

else
choice=i #btcpayinstallsbitcoin internal drive
fi

case $choice in

ext)
if [[ $1 == Bitcoin ]] ; then
    log "importdrive" "$1 install, choice to import drive"
    import_drive_options || return 1
    export drive="external" ; parmanode_conf_add "drive=external"
    installed_conf_add "bitcoin-start"
    export bitcoin_drive_import="true" #used later to avoid format prompt.
    return 0
else
    invalid
fi
;;

np)
if [[ $1 == nostr ]] ; then
    export drive_nostr=custom
    parmanode_conf_add "drive_nostr=custom"
    return 0
else
    invalid
fi
;;
   
#External drive setup
e|E) 
if [[ $1 == "Bitcoin" ]] ; then export drive="external"; parmanode_conf_add "drive=external" ; installed_conf_add "bitcoin-start" ; fi

if [[ $1 == "Fulcrum" ]] ; then export drive_fulcrum="external"
        debug " in Fulcrum .. e"
        parmanode_conf_add "drive_fulcrum=external" 
        debug "after pca"
        fi

if [[ $1 == "Electrs" ]] ; then export drive_electrs="external"
        parmanode_conf_add "drive_electrs=external" ; fi

if [[ $1 == "Electrumx" ]] ; then export drive_electrumx="external"
        parmanode_conf_add "drive_electrumx=external" ; fi

if [[ $1 == "nostr" ]] ; then export drive_nostr="external"
        parmanode_conf_add "drive_nostr=external" ; fi

debug "before return 0"
return 0
;;

byo | BYO)
if [[ $1 == "Bitcoin" ]] ; then 
    bitcoin_byo
    continue
fi
;;

i | I)
        if [[ $1 == "Bitcoin" ]] ; then export drive="internal" ; parmanode_conf_add "drive=internal" ; installed_conf_add "bitcoin-start" ; fi

        if [[ $1 == "Fulcrum" ]] ; then export drive_fulcrum="internal" 
               parmanode_conf_add "drive_fulcrum=internal"
               fi
        if [[ $1 == "Electrs" ]] ; then export drive_electrs="internal" 
               parmanode_conf_add "drive_electrs=internal"
               fi
        if [[ $1 == "Electrumx" ]] ; then export drive_electrumx="internal"
                parmanode_conf_add "drive_electrumx=internal" ; fi

        if [[ $1 == "nostr" ]] ; then export drive_nostr="internal"
                parmanode_conf_add "drive_nostr=internal" ; fi

        return 0 
        ;;

m|M) back2main ;;

q|Q|quit|QUIT|Quit)
        exit 0
        ;;
p|P)
        return 1 
        ;;
*)
        set_terminal
	invalid
        ;;  
esac
done
return 0
}
