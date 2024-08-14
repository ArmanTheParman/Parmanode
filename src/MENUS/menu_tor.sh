function menu_tor {
while true ; do

if [[ $OS == "Linux" ]] ; then 
    if sudo systemctl status tor | grep Active: | grep -q active ; then
    torrunning="true"
    torrunningtext="${green}RUNNING"
    else
    torrunning="false"
    torrunningtext="${red}NOT RUNNING"
    fi
fi

if [[ $OS == "Mac" ]] ; then true
    if brew services list | grep tor | grep -q "started" ; then 
    torrunning="true"
    torrunningtext="${green}RUNNING"
    else
    torrunning="false"
    torrunningtext="${red}NOT RUNNING"
    fi
fi

set_terminal ; echo -e "
########################################################################################

                     $cyan                    TOR    $orange

########################################################################################


                  STATUS:         Tor is $torrunningtext$orange



$cyan                  stop)         $orange  Stop Tor                  

$cyan                  start)      $orange    Start Tor (normally starts automatically)
                                                                 
$cyan                  restart)$orange        Restart Tor
                                                            

######################################################################################## 
"
choose "xpmq" ; read choice
case $choice in 
m|M) back2main ;;
Q|q|QUIT|Quit|quit) 
    exit 0 ;; 

p|P) 
menu_use ;; 

start|START) 
if [[ $OS == "Linux" ]] ; then sudo systemctl start tor && success "Tor" "starting" ; return 0 ; fi
if [[ $OS == "Mac" ]] ; then brew services start tor  && success "Tor" "starting" ; return 0 ;fi ;;

stop|STOP) 
if [[ $OS == "Linux" ]] ; then sudo systemctl stop tor ; success "Tor" "stopping" ; return 0 ; fi
if [[ $OS == "Mac" ]] ; then brew services stop tor ;  success "Tor" "stopping" ; return 0 ; fi ;;

restart|RESTART)
if [[ $OS == "Linux" ]] ; then sudo systemctl restart tor ; success "Tor" "restarting" ; return 0 ; fi
if [[ $OS == "Mac" ]] ; then brew services restart tor ; success "Tor" "restarting" ; return 0 ; fi
;;

*)
invalid ;;
esac  

done
return 0
}