function menu_torrelay {
while true ; do set_terminal ; echo -e "
########################################################################################
                 $cyan              Tor Relay Menu            $orange                   
########################################################################################


               i)        Tor Relay Information

########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in 
m|M) back2main ;;
q|Q|QUIT|Quit) exit 0 ;;
p|P) menu_use ;; 
i|I|info|Info|INFO)
log_counter
if [[ $log_count -le 100 ]] ; then
echo -e "
########################################################################################
    
    This next screen will show your Tor Relay status. 
    
    You can hit$cyan <control>-c$orange to make it stop.

########################################################################################
"
enter_continue
fi
set_terminal_wider
nyx
tail_PID=$!
trap 'kill $tail_PID' SIGINT #condition added to memory
wait $tail_PID # code waits here for user to control-c
trap - SIGINT # reset the trap so control-c works elsewhere.
return 0 ;;

*)
invalid
;;

esac
done
}