function user_pass_fulcrum {
while true ; do
echo "
########################################################################################

                               RPC Authentication

    Remote Procedure Call (RPC) is how wallet applications connect to Bitcoin
    Core. Fulcrum Server requires the rpcuser/rpcpassword method, rather than the
    cookie file method (if you dn't understand, don't worry about it.)
    
    You will now be able to type in what your username and password is in bitcoin.conf
    so that Fulcrum is given permission to connect. If you want to change the
    bitcoin.conf password, you can do that in the Bitcoin Core menu.

########################################################################################
"
choose "epq" ; read choice ; set_terminal 

case $choice in
        p|P)
        return o ;;
        q|Q|quit|QUIT|Quit)
        exit 0 ;;

	    "")
		echo "Please enter an RPC username:
	       	" 
		read rpcuser
		
		while true ; do
		set_terminal
		echo "Please enter an PRC password:
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

                delete_line "$HOME/parmanode/fulcrum/fulcrum.conf" "rpcuser"
                delete_line "$HOME/parmanode/fulcrum/fulcrum.conf" "rpcpassword"
				echo "rpcuser = $rpcuser" >> $HOME/parmanode/fulcrum/fulcrum.conf
				echo "rpcpassword = $rpcpassword" >> $HOME/parmanode/fulcrum/fulcrum.conf
		break
		;;

        *)
            invalid
            continue
            ;;	
esac

done
return 0
}
