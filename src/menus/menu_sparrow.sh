function menu_sparrow {
while true ; do set_terminal ; echo "
########################################################################################
                                Sparrow Menu                               
########################################################################################


      (start)          Start Sparrow 

      (rc)             remove configuration file and saved wallets


########################################################################################
"
choose "xpq" ; read choice ; set_terminal
case $choice in 
q|Q|QUIT|Quit) exit 0 ;;
p|P) return 1 ;;

start|Start|START|S|s)
if [[ $OS == "Linux" ]] ; then
nohup $HOME/parmanode/Sparrow/bin/Sparrow >/dev/null 2>&1 & 
please_wait
sleep 2
debug1 "debug"
fi

if [[ $OS == "Mac" ]] ; then 
open /Applications/Sparrow.app
fi

return 0 ;;

rc|RC|Rc|rC)
rm -rf $HOME/.sparrow/*
cp $original_dir/src/sparrow/config $HOME/.sparrow/
echo "The sparrow configuration directory has been emptied, and a new configuration file has been creatd."
enter_continue

;;

*)
invalid
;;

esac
done
}
