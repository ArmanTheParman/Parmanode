function set_rpc_authentication {
while true ; do
echo "
########################################################################################

                           Bitcoin Core RPC Authentication

    Remote Procedure Call (RPC) is how other applications connect to Bitcoin
    Core. The default authentication method is a cookie file stored in the Bitcoin
    data directory. Some software (eg Fulcrum Server) REQUIRES the alternative 
    way, which is with a username and password. You can set a username and password 
    here.


          (up) Set username and password ...... (must be set if installing Fulcrum)

          (u)  Leave username and password unchanged

          (c)  Use cookie ..................... (default setting)

	

	If you make changes, you MUST restart Bitcoin and Fulcrum (not Parmanode) for 
	those changes to take effect.

########################################################################################

"
choose "xpq" ; exit_choice ; if [ $? = 1 ] ; then return 1 ; fi ; set_terminal

case $choice in
	up|UP|Up|uP)
		echo "Please enter an RPC username: (Do not use the characters: # \" or '"
		echo "otherwise problems may arise.)
	       	" 
		read rpcuser
		
		while true ; do
		set_terminal
		echo "Please enter an RPC password: (Do not use the characters: # \" or '"
		echo "otherwise problems may arise.)
	       	" 
		read rpcpassword
		echo "Please repeat the password:
	       	"
		read rpcpassword2
		
		if [[ $rpcpassword != $rpcpassword2 ]] ; then
		       echo "Passwords do not match. Try again.
		       "
                   continue
		else
	               break
		fi

		done

                delete_line "$HOME/.bitcoin/bitcoin.conf" "rpcuser"
                delete_line "$HOME/.bitcoin/bitcoin.conf" "rpcpassword"
				echo "rpcuser=$rpcuser" >> $HOME/.bitcoin/bitcoin.conf
				echo "rpcpassword=$rpcpassword" >> $HOME/.bitcoin/bitcoin.conf
				parmanode_conf_add "rpcuser=$rpcuser"
				parmanode_conf_add "rpcpassword=$rpcpassword"	
		break
		;;

	u|U) break ;;

	c)
                delete_line "$HOME/.bitcoin/bitcoin.conf" "rpcuser"
                delete_line "$HOME/.bitcoin/bitcoin.conf" "rpcpassword"
		;;	

	*)
		invalid
		continue
		;;	
esac

done
return 0
}
