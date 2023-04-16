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

                          
                              e)     external drive

                              i)     internal drive   

########################################################################################
"
choose "xpq" ; read choice

case $choice in q|Q|QUIT|Quit) exit 1 ;; p|P) return 1 ;;
    e|E) fulcrum_drive="external" ;;
    i|I) fulcrum_drive="internal" ;;
    *) invalid ;;
    esac

parmanode_conf_add "fulcrum_drive=${fulcrum_drive}"

done
}
