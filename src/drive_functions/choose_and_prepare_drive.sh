function choose_and_prepare_drive {
if [[ $version == self ]] ; then return 0 ; fi
# Expect argument, either Bitcoin or Fulcrum or Electrs or Electrumx or nostr for $1
# chooses between internal and external drive
# Should have called the function "choose_and_prepare_drive, without "parmanode" - fix later"

local text="$bright_blue                (3) - IMPORT an external drive
                                 (Parmanode, Umbrel, RaspiBlitz or MyNode) $orange
" 

local text_nostr="                (4) - BYO eg an additional external drive" 

while true
do
unset raid
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
$pink
                (aa)    Use an EXTERNAL drive RAID array $orange
"
if [[ $1 == Bitcoin || $1 == nostr ]] ; then
echo -e "$text" ; fi 
if [[ $1 == nostr ]] ; then
echo -e "$text_nostr" ; fi
echo "########################################################################################
"
choose "xpmq" #echo statment about above options, previous menu, or quit.

read choice #user's choice stored in variable, choice

if [[ $choice == aa ]] ; then choice=e ; export raid="true" ; fi
case $choice in
3)
log "importdrive" "$1 install, choice to import drive"
import_drive_options || return 1
export drive="external" ; parmanode_conf_add "drive=external"
export bitcoin_drive_import="true" #used later to avoid format prompt.
return 0
;;

4)
export drive_nostr=custom
parmanode_conf_add "drive_nostr=custom"
return 0
;;
e | E)    #External drive setup

if [[ $1 == "Bitcoin" ]] ; then export drive="external"; parmanode_conf_add "drive=external" ; fi

if [[ $1 == "Fulcrum" ]] ; then export drive_fulcrum="external"
        parmanode_conf_add "drive_fulcrum=external" ; fi

if [[ $1 == "Electrs" ]] ; then export drive_electrs="external"
        parmanode_conf_add "drive_electrs=external" ; fi

if [[ $1 == "Electrumx" ]] ; then export drive_electrumx="external"
        parmanode_conf_add "drive_electrumx=external" ; fi

if [[ $1 == "nostr" ]] ; then export drive_nostr="external"
        parmanode_conf_add "drive_nostr=external" ; fi

return 0

;;

i | I)
        if [[ $1 == "Bitcoin" ]] ; then export drive="internal" ; parmanode_conf_add "drive=internal" ; fi

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
