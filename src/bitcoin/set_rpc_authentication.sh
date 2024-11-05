function set_rpc_authentication {
if [[ $bitcoin == "yolo" ]]
	then export rpcuser=null ; export rpcpassword=null
	return 0 
	fi

while true ; do
set_terminal_bit_higher  

if [[ -z $1 ]] ; then
echo -e "
########################################################################################
$cyan
                           Bitcoin Core RPC Authentication
$orange
    Remote Procedure Call (RPC) is how other applications (like wallets) connect to 
    Bitcoin Core. 
    So that no random software connects to Bitcoin Core, a username/password 
    authentication challenge is introduced. Note, this password doesn't need to be 
    incredibly secure, and do also bear in mind that it will be stored on the 
    computer in$pink clear text$orange (i.e. unencrypted) inside the bitcoin.conf
    file and other configuration files. Therefore, don't use highly sensitive
    passwords that you might use for other things.

    If you decide to change the default username/password (parman/parman), then
    make sure you$pink$blinkon do not use any symbols$blinkoff$orange, as some of 
    them are interpreted by the computer as commands rather than plain text.

$green
       (s)     Set the Bitcoin username and password (edits bitcoin.conf for you)
$orange
       (L)     Leave Bitcoin username and password unchanged 
$red
       (c)     Use cookie ...(deletes password from bitcoin.conf) - DON'T
$orange
########################################################################################

"
choose "xpmq" ; read choice
else
choice=$1
fi

case $choice in
m|M) back2main ;;
    s|S)
	            if [[ $2 == install ]] ; then
				export rpcuser=parman
				export rpcpassword=parman
				else
	            password_changer
				fi
				 
				if [[ $2 != install ]] ; then #no need to stop bitcoin if it hasn't been installed yet.
	            stop_bitcoind  
				fi

                set_rpc_authentication_update_conf_edits #defined below
				
				export btc_authentication="user/pass" >/dev/null
				parmanode_conf_remove "btc_authentication" && parmanode_conf_add "btc_authentication=$btc_authentication"

                if [[ ! $dontstartbitcoin == "true" ]] ; then #will run unless dontstartbitcoin=true
				sleep 1 
				echo "Starting Bitcoin"
				run_bitcoind
				fi

                break
		        ;;
		
	l|L) 
				break
				;;
	c)
	            stop_bitcoind
                sudo gsed -i "/rpcuser/d" $bc && unset rpcuser
                sudo gsed -i "/rpcpassword/d" $bc && unset rpcpassword

				export btc_authentication="cookie"
				parmanode_conf_remove "btc_authentication" && parmanode_conf_add "btc_authentication=$btc_authentication"

                if [[ ! $dontstartbitcoin == "true" ]] ; then #will run unless dontstartbitcoin=true
				sleep 1
				run_bitcoind 
				fi
				return 1 #important for testing if user/pass set
	;;

	p|P) return 1 ;; #important for testing if user/pass set

	q|Q|Quit|QUIT) exit 0 ;;

	*)
		invalid
		;;	
esac

done
check_rpc_credentials_match
return 0
}

function set_rpc_authentication_update_conf_edits {

	sudo gsed -i "/rpcuser/d" $bc >/dev/null 2>&1
	sudo gsed -i "/rpcpassword/d" $bc >/dev/null 2>&1
	echo "rpcuser=$rpcuser" >> $bc 2>&1
	echo "rpcpassword=$rpcpassword" >> $bc 2>&1
	parmanode_conf_add "rpcuser=$rpcuser"
	parmanode_conf_add "rpcpassword=$rpcpassword"

set_terminal

if [[ ! $dontstartbitcoin == "true" ]] ; then #will run unless dontstartbitcoin=true
run_bitcoind
fi

}

function add_userpass_to_fulcrum {

source $pc >/dev/null 2>&1

sudo gsed -i "/rpcuser/d" $fc 
sudo gsed -i "/rpcpassword/d" $fc 
echo "rpcuser = $rpcuser" >> $fc 2>/dev/null
echo "rpcpassword = $rpcpassword" >> $fc 2>/dev/null

}