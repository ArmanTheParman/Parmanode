function menu_torrelay {
if ! grep -q "torrelay-end" $ic ; then return 0 ; fi
while true ; do set_terminal ; echo -e "
########################################################################################
                 $cyan              Tor Relay Menu            $orange                   
########################################################################################

$cyan
               i)$orange        Tor Relay Information (via Nyx software)
$green
               start)$orange    Start Tor
$red
               stop)$orange     Stop Tor
$cyan
               r)$orange        Restart Tor
$cyan
               status)$orange   Tor Status

########################################################################################
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in 
m|M) back2main ;; q|Q|QUIT|Quit) exit 0 ;; p|P) menu_use ;; 
i|I|info|Info|INFO)
log_counter
if [[ $log_count -le 100 ]] ; then
echo -e "
########################################################################################
    
    This next screen will show your Tor Relay status. 
    
    You can hit$cyan <control>-c$orange to make it stop.

########################################################################################
"
enter_continue ; jump $enter_cont
fi
set_terminal 38 200
nyx
tail_PID=$!
trap 'kill $tail_PID' SIGINT #condition added to memory
wait $tail_PID # code waits here for user to control-c
trap - SIGINT # reset the trap so control-c works elsewhere.
return 0 ;;

start|START) 
if [[ $OS == "Linux" ]] ; then sudo systemctl start tor && success "Tor" "starting" ; continue ; fi
if [[ $OS == "Mac" ]] ; then brew services start tor  && success "Tor" "starting" ; continue ;fi ;;

stop|STOP) 
if [[ $OS == "Linux" ]] ; then sudo systemctl stop tor ; success "Tor" "stopping" ; continue ; fi
if [[ $OS == "Mac" ]] ; then brew services stop tor ;  success "Tor" "stopping" ; continue ; fi ;;

status|STATUS) 
if [[ $OS == "Linux" ]] ; then sudo systemctl status tor ; enter_continue ; continue ; fi
if [[ $OS == "Mac" ]] ; then true
    if brew services list | grep tor | grep "started" >$dn 2>&1 ; then set_terminal ; echo "Tor is running"
    enter_continue
    else
    set_terminal ; echo "Tor is not running"
    enter_continue
    continue
    fi
fi
;;

r|R|restart|RESTART)
if [[ $OS == "Linux" ]] ; then sudo systemctl restart tor ; success "Tor" "restarting" ; continue ; fi
if [[ $OS == "Mac" ]] ; then brew services restart tor ; success "Tor" "restarting" ; continue ; fi
;;
"")
continue ;;
*)
invalid
;;

esac
done
}