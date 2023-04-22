function warning_deleting_fulcrum {

set_terminal ; echo "
########################################################################################

    WARNING: If you have a previous Fulcrum Docker container, this installation will 
    delete it, and any Fulcrum images. We're starting fresh, too bad. If you want to 
    preserve any old data, you should quit now, and back them up. If you don't know 
    how... see internet  ;p

                              <enter>    to continue

########################################################################################
"
choose "xpq" ; read choice
case $choice in q|Q|QUIT|Quit) exit 0 ;; p|P) return 1 ;; *) return 0  ;; esac 
return 0
}