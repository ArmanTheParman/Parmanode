#not used any more. Task allocated to choose_and_prepare_drive

function fulcrum_drive_selection {

set_terminal
while true ; do
echo "
########################################################################################

                               Drive Selection: Fulcrum

########################################################################################

    Fulcrum will build a database using the Bitcoin blockchain data for rapid access
    for your wallet. This data can be kept on the internal or external drive - it does
    not have to be on the same drive as the Bitcoin data. It will take around 100 Gb
    of data.
                          fulcrum_drive_selection
########################################################################################
"
choose "xpq" ; read choice

case $choice in q|Q|QUIT|Quit) exit 1 ;; p|P) return 1 ;;
    e|E) export drive_fulcrum="external" ; break ;;
    i|I) export drive_fulcrum="internal" ; break ;;
    *) invalid ;;
    esac
done


set_terminal

if cat $HOME/.parmanode/parmanode.conf | grep drive=external ; then
echo "Please make sure the drive you use for the Bitcoin blocks is connected."
enter_continue
else

echo "Please connect a hard drive to be formatted. Otherwise type i to use the"
echo "internal drive."
    read choice
    if [[ $choice == "i" ]] ; then export drive_fulcrum="internal" ; return 0 ; fi

echo "Please connect the drive you wish to use."
enter_continue

parmanode_conf_add "drive_fulcrum=${drive_fulcrum}" && return 0
fi
}
