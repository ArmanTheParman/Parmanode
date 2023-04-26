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

    (p)  Exit this menu

    (s) Set Bitcoin username and password
        and copy to Fulcrum configuration ....... (must use password if
                                                   installing Fulcrum)
	
	d)  Set Bitcoin username and password
	    and DON'T copy anywhere else


    (L)  Leave username and password unchanged ...(and add to Fulcrum configuration)


    (c)  Use cookie ............................. (default setting for Bitcoin only.
                                                   Won't work with Fulcrum.) 


    If you make changes, you MUST restart Bitcoin and Fulcrum (not Parmanode) for 
	those changes to take effect.

########################################################################################

"
choose "xpq" ; read choice

case $choice in
    s|S)
	            password_changer
				 
                set_rpc_authentication_update_conf_edits #defined below

				add_userpass_to_fulcrum	

	    continue	
		;;
		
	d|D)        password_changer

                set_rpc_authentication_update_conf_edits

	    continue
		;;

	l|L) 
				add_userpass_to_fulcrum
				;;
	c)
                delete_line "$HOME/.bitcoin/bitcoin.conf" "rpcuser" && unset rpcuser
                delete_line "$HOME/.bitcoin/bitcoin.conf" "rpcpassword" && unset rpcpassword
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
	
	set_terminal ; echo "
########################################################################################

    Bitcoin must be (will be) stopped before changing passwords, otherwise you won't 
	be permitted to stop Bitcoin later (the starting Bitcoin password won't match the
	stopping Bitcoin pasword).

########################################################################################
"
enter_continue
stop_bitcoind ; if [ $? == 1 ] ; then ; echo "Unable to stop bitcoin daemon. Aborting password change."
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

source $HOME/.parmanode/parmanode.conf

	if [[ $OS == "Mac" ]] ; then edit_user_pass_fulcrum_docker ; fi

	if [[ $OS == "Linux" ]] ; then
					delete_line "$HOME/parmanode/fulcrum/fulcrum.conf" "rpcuser"
					delete_line "$HOME/parmanode/fulcrum/fulcrum.conf" "rpcpassword"
					echo "rpcuser = $rpcuser" >> $HOME/parmanode/fulcrum/fulcrum.conf
					echo "rpcpassword = $rpcpassword" >> $HOME/parmanode/fulcrum/fulcrum.conf
					fi

}