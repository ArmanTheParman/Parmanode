function user_pass_fulcrum {
while true ; do
echo "
########################################################################################

                               RPC Authentication

    Remote Procedure Call (RPC) is how other applications connect to Bitcoin
    Core. Fulcrum Server requires the rpcuser/rpcpassword method, rather than the
    cookie file method (if you dn't understand, don't worry about it).
    
	Parmanode will detect your username and password which is stored in the
	bitcoin.conf file. You can change it, and Parmanode will sync the information in
	both the Bitcoin and Fulcrum configuration files.

							l)    leave user/password as is

							c)    chenge user/password

	You MUST restart Bitcoin and Fulcrum (not Parmanode) if you have made any changes 
	here for those changes to take effect.

########################################################################################
"
choose "xpq" ; read choice ; set_terminal 

case $choice in
        p|P|l|L)
        return o ;;
        q|Q|quit|QUIT|Quit)
        exit 0 ;;

	    c|C)
		set_terminal
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
			   set_terminal
		       echo "Passwords do not match. Try again.

		       "
               continue
			   else  break ; fi

		done #end while 1

		add_userpass_to_fulcrum

		break
		;;

        *)
            invalid
            continue
            ;;	
esac

done #end while 2
return 0
}

function fulcrum_extract_user_pass {

cat $HOME/.bitcoin/bitcoin.conf | grep "rpcuser="


}