function set_rpc_authentication {
if [[ $bitcoin == "yolo" ]]
	then export rpcuser=null ; export rpcpassword=null
	return 
	fi

while true ; do
set_terminal_bit_higher ; echo "
########################################################################################

                           Bitcoin Core RPC Authentication

    Remote Procedure Call (RPC) is how other applications (like wallets) connect to 
    Bitcoin Core. The default authentication method is with what's caled a COOKIE 
    FILE Stored in the Bitcoin data directory. 
	
    Some software (eg Fulcrum Server) REQUIRES the alternative way, which is with a 
    USERNAME And PASSWORD. For convenience, you can set a username and password here.

	Please be aware changing a setting here to make one wallet work, can mess up
	another. For example, if you first installed Sparrow and if works fine, then you
	decided to install Fulcrum, you'll need to set a password for bitcoin. If you do
	that, Sparrow will no longer connect unless you go into the network preferences
	and enter the username/password.

       (s) Set the Bitcoin username and password (edits bitcoin.conf)

       (L) Leave Bitcoin username and password unchanged 

       (c) Use cookie ...(deletes from bitcoin.conf; Won't work with Fulcrum) 

       (p) Exit this menu (set username/pass from menu later)


########################################################################################

"
choose "xpq" ; read choice

case $choice in
    s|S)
	            password_changer
				 
	            stop_bitcoind  
                set_rpc_authentication_update_conf_edits #defined below

				add_userpass_to_fulcrum 
				#(extracted from bitcoin.conf)	
				#checks if fulcrum installed, otherwise returns
				
				export btc_authentication="user/pass"
				parmanode_conf_remove "btc_authentication" && parmanode_conf_add "btc_authentication=$btc_authentication"

				sleep 1 
				echo "Starting Bitcoin"
				run_bitcoind

                break
		        ;;
		
	l|L) 
				add_userpass_to_fulcrum
				break
				;;
	c)
	            stop_bitcoind
                delete_line "$HOME/.bitcoin/bitcoin.conf" "rpcuser" && unset rpcuser
                delete_line "$HOME/.bitcoin/bitcoin.conf" "rpcpassword" && unset rpcpassword

				export btc_authentication="cookie"
				parmanode_conf_remove "btc_authentication" && parmanode_conf_add "btc_authentication=$btc_authentication"

				sleep 1
				run_bitcoind 
				break
		;;	

	p|P) return 0 ;;

	q|Q|Quit|QUIT) exit 0 ;;

	*)
		invalid
		;;	
esac

done
return 0
}

function set_rpc_authentication_update_conf_edits {

	delete_line "$HOME/.bitcoin/bitcoin.conf" "rpcuser" >/dev/null 2>&1
	delete_line "$HOME/.bitcoin/bitcoin.conf" "rpcpassword" >/dev/null 2>&1
	echo "rpcuser=$rpcuser" >> $HOME/.bitcoin/bitcoin.conf 2>&1
	echo "rpcpassword=$rpcpassword" >> $HOME/.bitcoin/bitcoin.conf 2>&1
	parmanode_conf_add "rpcuser=$rpcuser"
	parmanode_conf_add "rpcpassword=$rpcpassword"

set_terminal

run_bitcoind

}

function add_userpass_to_fulcrum {

source $HOME/.parmanode/parmanode.conf >/dev/null 2>&1

	if cat $HOME/.parmanode/installed.conf | grep -q "fulcrum-end" ; then
		true
	else
		return 1
	fi

	if [[ $OS == "Mac" ]] ; then edit_user_pass_fulcrum_docker ; return 0 ; fi

	if [[ $OS == "Linux" ]] ; then
					delete_line "$HOME/parmanode/fulcrum/fulcrum.conf" "rpcuser"
					delete_line "$HOME/parmanode/fulcrum/fulcrum.conf" "rpcpassword"
					echo "rpcuser = $rpcuser" >> $HOME/parmanode/fulcrum/fulcrum.conf
					echo "rpcpassword = $rpcpassword" >> $HOME/parmanode/fulcrum/fulcrum.conf
					return 0
					fi

}