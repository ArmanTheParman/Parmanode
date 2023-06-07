function menu_sparrow {
while true ; do set_terminal ; echo "
########################################################################################
                                Sparrow Menu                               
########################################################################################


      (start)          Start Sparrow 


      (u)              Install \"udev\" rules for Hardware Wallets

                           - usually necessary for HWWs to work
                           - not required for Mac computers

########################################################################################
"
choose "xpq" ; read choice ; set_terminal
case $choice in 
q|Q|QUIT|Quit) exit 0 ;;
p|P) return 1 ;;

start|Start|START|S|s)
run_sparrow
return 0 ;;

#rc|RC|Rc|rC)
#rm -rf $HOME/.sparrow/*
#cp $original_dir/src/sparrow/config $HOME/.sparrow/
#echo "The sparrow configuration directory has been emptied, and a new configuration file has been creatd."
#enter_continue
#;;

u|U)
sparrow_udev
return 0
;;


*)
invalid
;;

esac
done
}
