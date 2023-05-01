function set_rpc_authentication {
while true ; do
set_terminal_bit_higher ; echo "
########################################################################################

                           Bitcoin Core RPC Authentication

    Remote Procedure Call (RPC) is how other applications (like wallets) connect to 
	Bitcoin Core. The default authentication method is with what's caled a COOKIE 
	FILE Stored in the Bitcoin data directory. 
	
	Some software (eg Fulcrum Server) REQUIRES the alternative way, which is with a 
	USERNAME And PASSWORD. For convenience, you can set a username and password here.



       (s) Set the Bitcoin username and password (edits bitcoin.conf)

       (L) Leave Bitcoin username and password unchanged 

       (c) Use cookie ...(deletes from bitocin.conf; Won't work with Fulcrum) 

       (p) Exit this menu (set username/pass from menu later)



    If you make changminute or sotake effect.

########################################################################################

"
choose "xpq" ; read choice

case $choice in
    s|S)
	            password_changer
				 
                set_rpc_authentication_update_conf_edits #defined below

				add_userpass_to_fulcrum #(extracted from bitcoin.conf)	

	    break	
		;;
		
	l|L) 
				add_userpass_to_fulcrum
				break
				;;
	c)
                delete_line "$HOME/.bitcoin/bitcoin.conf" "rpcuser" && unset rpcuser
                delete_line "$HOME/.bitcoin/bitcoin.conf" "rpcpassword" && unset rpcpassword
				break
		;;	

	p|P) return 0 ;;

	q|Q|Quit|QUIT) exit 0 ;;

	*)
		invalid
		;;	
esac

done
}

function set_rpc_authentication_update_conf_edits {

stop_bitcoind ; if [ $? == 1 ] ; then echo "Unable to stop bitcoin daemon. Aborting password change."
										enter_continue ; return 1 ; fi

	delete_line "$HOME/.bitcoin/bitcoin.conf" "rpcuser"
	delete_line "$HOME/.bitcoin/bitcoin.conf" "rpcpassword"
	echo "rpcuser=$rpcuser" >> $HOME/.bitcoin/bitcoin.conf
	echo "rpcpassword=$rpcpassword" >> $HOME/.bitcoin/bitcoin.conf
	parmanode_conf_add "rpcuser=$rpcuser"
	parmanode_conf_add "rpcpassword=$rpcpassword"

run_bitcoind

}

function add_userpass_to_fulcrum {

source $HOME/.parmanode/parmanode.conf >/dev/null 2>&1

	if [[ $OS == "Mac" ]] ; then edit_user_pass_fulcrum_docker ; fi

	if [[ $OS == "Linux" ]] ; then
					delete_line "$HOME/parmanode/fulcrum/fulcrum.conf" "rpcuser"
					delete_line "$HOME/parmanode/fulcrum/fulcrum.conf" "rpcpassword"
					echo "rpcuser = $rpcuser" >> $HOME/parmanode/fulcrum/fulcrum.conf
					echo "rpcpassword = $rpcpassword" >> $HOME/parmanode/fulcrum/fulcrum.conf
					fi

}