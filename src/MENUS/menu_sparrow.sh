function menu_sparrow {
while true ; do 
unset sversion
if [[ $OS == Mac ]] ; then
sversion=$(/Applications/Sparrow.app/Contents/MacOS/Sparrow --version | grep -Eo '[0-9].+$')
else
sversion=$($hp/Sparrow/bin/Sparrow --version | grep -Eo '[0-9].+$')
fi

source $HOME/.parmanode/sparrow.connection >/dev/null

set_terminal ; echo -e "
########################################################################################
                  $cyan         Sparrow Menu -- Version $sversion                  $orange      
########################################################################################

                      SPARROW CONNECTION TYPE: $cyan$connection$orange


   $green      (start) $orange                Start Sparrow 

----------------------------------------------------------------------------------------
$cyan
                          CONNECTION OPTIONS  $orange
                          
         (d)       Bitcoin Core via tcp (default)

         (fs)      Fulcrum via ssl (port 50002)

         (ft)      Fulcrum via tcp (port 50001)

         (ftor)    Fulcrum via Tor (port 7002)

         (et)      electrs via tcp (port 50005)
        
          N/A      electrs via SSL (Not available)

         (etor)    electrs via Tor (port 7004) 

         (rtor)    To a remote Electrum/Fulcrum server via Tor (eg a friend's)
         
----------------------------------------------------------------------------------------

         (sc)      View/Edit Sparrow config file (use with care)

         (t)       Troubleshooting

########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in 
m|M) back2main ;;
q|Q|QUIT|Quit) exit 0 ;;
p|P) menu_use ;; 
start|Start|START|S|s)
check_SSH || return 0
check_wallet_connected "Sparrow"
run_sparrow
return 0 ;;

d|D)
sparrow_core
;;

ftor)
no_mac || return 1
sparrow_fulcrumtor
;;

etor)
no_mac || return 1
sparrow_electrstor
;;

fs)
no_mac || return 1
sparrow_fulcrumssl
;;

ft)
sparrow_fulcrumtcp
;;

rtor|Rtor|RTOR)
sparrow_remote
;;

et)
sparrow_electrs
;;

sc|SC|Sc)
echo -e "
########################################################################################
    
        This will run Nano text editor to edit 
$cyan 
        $HOME/.sparrow/config
$orange    
        See the controls at the bottom to save and exit. Be careful messing around 
        with this file.

        Any changes will only be applied once you restart Bitcoin.
$green
        Note, every time you change the sparrow connection type from the Parmanode
        menu, the config file will be replaced/refeshed.
$orange
########################################################################################
"
enter_continue
nano $HOME/.sparrow/config
continue
;;

t|T)
troubleshooting_sparrow
;;

*)
invalid
;;

esac
done
}

