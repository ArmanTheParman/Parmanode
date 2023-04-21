function warning_deleting_fulcrum {

set_terminal ; echo "
########################################################################################

WARNING: If you have a previous Fulcrum container, this installation will delete it,
and any Fulcrum images. We're starting fresh, too bad. If you want to preserve any old
data, you should quit now, and back them up. If you don't know how... internet  ;p

                               <enter> to continue

########################################################################################
"
choose "xpq" ; read choice
 while true ; do case $choice in q|Q|QUIT|Quit) exit 0 ;; p|P) return 1 ;; "") break ;; *) invalid ;; esac ; done

}