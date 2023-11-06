########################################################################################
########################################################################################
########################################################################################
#          not used any more. Task allocated to choose_and_prepare_drive               #
########################################################################################
########################################################################################
########################################################################################
function fulcrum_drive_selection {

if [ -z $1 ] ; then serverE="Fulcrum" ; fi
if [[ $1 == "electrs" ]] ; then serverE="electrs" ; fi

set_terminal
while true ; do
echo "
########################################################################################

                               Drive Selection: $serverE 

########################################################################################

    $serverE will build a database using the Bitcoin blockchain data for rapid access
    for your wallet. This data can be kept on the internal or external drive - it does
    not have to be on the same drive as the Bitcoin data. It might take around 100 Gb
    of data.

                        e)      External drive

                        i)      Internal drive

########################################################################################
"
choose "xpmq" ; read choice

case $choice in q|Q|QUIT|Quit) exit 1 ;; p|P) return 1 ;;
m|M) back2main ;;
    
    e|E) 
    if [[ $serverE == "fulcrum" ]] ; then export drive_fulcrum="external" ; break ; fi 
    if [[ $serverE == "electrs" ]] ; then export drive_electrs="external" ; break ; fi 
    ;;

    i|I) 
    if [[ $serverE == "fulcrum" ]] ; then export drive_fulcrum="internal" ; break ; fi
    if [[ $serverE == "electrs" ]] ; then export drive_electrs="internal" ; break ; fi
    ;; 

    *) invalid ;;
    esac
done


set_terminal

if cat $HOME/.parmanode/parmanode.conf | grep drive=external ; then
echo "Please make sure the drive you use for the Bitcoin blocks is connected."
enter_continue
else

annoutce "Please connect a hard drive to be formatted. Otherwise type i to use the" "internal drive."
read choice

    if [[ $choice == "i" ]] ; then 
      if [[ $serverE == "fulcrum" ]] ; then export drive_fulcrum="internal" ; return 0 ; fi 
      if [[ $serverE == "electrs" ]] ; then export drive_electrs="internal" ; return 0 ; fi
    fi

echo "Please connect the drive you wish to use."
enter_continue
fi # end if drive external

if [[ $serverE == "fulcrum" ]] ; then
    parmanode_conf_add "drive_fulcrum=${drive_fulcrum}" && return 0
fi

if [[ $serverE == "electrs" ]] ; then
    parmanode_conf_add "drive_electrs=${drive_electrs}" && return 0

fi
}
