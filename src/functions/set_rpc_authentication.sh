function set_rpc_authentication {
while true ; do
set_terminal ; echo "
########################################################################################

                           Bitcoin Core RPC Authentication

    Remote Procedure Call (RPC) is how other applications connect to Bitcoin
    Core. The default authentication method is a cookie file stored in the Bitcoin
    data directory. Some software (eg Fulcrum Server) REQUIRES the alternative 
    way, which is with a username and password. You can set a username and password 
    here.


    (s) Set Bitcoin username and password
         and copy to Fulcrum configuration ...... (must use password if
                                                    installing Fulcrum)

    (L)  Leave username and password unchanged ...(and add to Fulcrum configuration)


    (c)  Use cookie ............................. (default setting for Bitcoin only.
                                                   Won't work with Fulcrum.) 

    (p)  Exit this menu

    If you make changes, you MUST restart Bitcoin and Fulcrum (not Parmanode) for 
	those changes to take effect.

########################################################################################

"
choose "xpq" ; read choice

case $choice in
    s|S)
	    set_terminal
		echo "Please enter an RPC username: (Do not use the characters: # \" or '"
		echo "otherwise problems may arise.)
	       	" 
		read rpcuser
		while true ; do
		set_terminal
		echo "Username set
		"	
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
			   enter_continue ; continue 
		else
	           echo "Password set"    
			   enter_continue ; break
		fi

		done
                set_rpc_authentication_update_conf_edits #defined below

				add_userpass_to_fulcrum	

	    continue	
		;;

	l|L) 
				add_userpass_to_fulcrum
				;;
	c)
                delete_line "$HOME/.bitcoin/bitcoin.conf" "rpcuser" && unset rpcuser
                delete_line "$HOME/.bitcoin/bitcoin.conf" "rpcpassword" && unset rpcpassword
		;;	

	p|P) break ;;
	q|Q|Quit|QUIT) exit 0 ;;

	*)
		invalid
		;;	
esac

done
return 0
}

function set_rpc_authentication_update_conf_edits {

	delete_line "$HOME/.bitcoin/bitcoin.conf" "rpcuser"
	delete_line "$HOME/.bitcoin/bitcoin.conf" "rpcpassword"
	echo "rpcuser=$rpcuser" >> $HOME/.bitcoin/bitcoin.conf
	echo "rpcpassword=$rpcpassword" >> $HOME/.bitcoin/bitcoin.conf
	parmanode_conf_add "rpcuser=$rpcuser"
	parmanode_conf_add "rpcpassword=$rpcpassword"

}

function add_userpass_to_fulcrum {

source $HOME/.parmanode/parmanode.conf

	if [[ $OS == "Mac" ]] ; then edit_user_pass_fulcrum_docker ; fi

	if [[ $OS == "Linux" ]] ; then
					delete_line "$HOME/parmanode/fulcrum/fulcrum.conf" "rpcuser"
					delete_line "$HOME/parmanode/fulcrum/fulcrum.conf" "rpcpassword"
					echo "rpcuser = $rpcuser" >> $HOME/parmanode/fulcrum/fulcrum.conf
					echo "rpcpassword = $rpcpassword" >> $HOME/parmanode/fulcrum/fulcrum.conf
					fi

}