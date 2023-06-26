function menu_sparrow {
while true ; do set_terminal ; echo "
########################################################################################
                                Sparrow Menu                               
########################################################################################

      (start)          Start Sparrow 

      (d)         Connect Sparrow directly to Bitcoin Core via tcp (defualt)

      (tor)       Connect Sparrow via Tor

      (ssl)       Connect Sparrow to Fulcrum vis ssl

########################################################################################
"
choose "xpq" ; read choice ; set_terminal
case $choice in 
q|Q|QUIT|Quit) exit 0 ;;
p|P) return 1 ;;

start|Start|START|S|s)
run_sparrow
return 0 ;;

d|D)
sparrow_core
;;

tor|Tor|TOR)
sparrow_fulcrumtor
;;

ssl|Ssl|SSL)
sparrow_fulcrumssl
;;

#rc|RC|Rc|rC)
#rm -rf $HOME/.sparrow/*
#cp $original_dir/src/sparrow/config $HOME/.sparrow/
#echo "The sparrow configuration directory has been emptied, and a new configuration file has been creatd."
#enter_continue
#;;

*)
invalid
;;

esac
done
}
