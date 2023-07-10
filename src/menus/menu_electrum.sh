function menu_electrum {
while true ; do set_terminal ; echo "
########################################################################################
                                Electrum Menu                               
########################################################################################

             (start)            Start Electrum 
"
if ! cat $HOME/.electrum/config | grep "\"server" | grep "onion" ; then echo " 
             (tor)              Enable Tor Connection      [Currently Disabled]" 
etor=off
else
echo "
             (tor)              Disable Tor Connection      [Currently Enabled]"
etor=on
fi
echo "

########################################################################################
"
choose "xpq" ; read choice ; set_terminal
case $choice in 
q|Q|QUIT|Quit) exit 0 ;;
p|P) return 1 ;;

start|Start|START|S|s)
run_electrum
enter_continue
return 0 ;;

tor|TOR|t|T)
#if [[ $OS == "Mac" ]] ; then no_mac ; fi
etor=off
if [[ $OS == "Mac" && $etor == "off" ]] ; then enable_electrum_tor ; fi
if [[ $OS == "Mac" && $etor == "on" ]] ; then disable_electrum_tor; fi
if [[ $OS == "Linux" && $etor == "off" ]] ; then enable_electrum_tor ; fi
if [[ $OS == "Linux" && $etor == "on" ]] ; then disable_electrum_tor; fi
;;

*)
invalid
;;

esac
done
}
