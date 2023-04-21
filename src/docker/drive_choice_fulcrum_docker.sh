function drive_choice_fulcrum_docker {

while true ; do
set_terminal ; echo "
########################################################################################

    Would you like the Fulcrum database to be kept on the internal drive or external
    drive? The database requires around 100 Gb of storage space.

    An external drive can only be chosen if a previously prepared parmanode external
    drive has been prepared (eg during parmanode instalation or bitcoin installation)
    

                                i)      Internal

                                e)      External

########################################################################################
"
choose "xpq" ; read choice

case $choice in Q|q|Quit|QUIT) exit 0 ;; p|P) return 1 ;; 
i|I) make_internal_fulcrum_db ; return 0 ;;
e|E) make_external_fucrum_db ; return 0 ;;
*) invalid
esac
done

}