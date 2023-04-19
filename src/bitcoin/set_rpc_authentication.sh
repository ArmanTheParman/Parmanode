function set_rpc_authentication {
while true ; do
echo "
########################################################################################

                               RPC Authentication

    Remote Procedure Call (RPC) is how wallet applications connect to Bitcoin
    Core. The default authentication method is a cookie file stored in the Bitcoin
    data directory. Some software (eg Fulcrum Server) might prefer the alternative 
	way which is with a username and password. If you require this, you can select 
	that here (up) or manually edit the bitcoin.conf file yourself.

                         (up) set a username and password

			 (c)  use cookie (default setting)

########################################################################################

"
choose "xpq" ; exit_choice ; if [ $? = 1 ] ; then return 1 ; fi ; set_terminal

case $choice in
	up|UP|Up|uP)
		echo "Please enter an RPC username: (Do not use the characters: # \" or ' otherwise problems may arise.)
	       	" 
		read rpcuser
		
		while true ; do
		set_terminal
		echo "Please enter an PRC password: (Do not use the characters: # \" or ' otherwise problems may arise.)
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
