function connect_wallet_info {
while true
do
set_terminal_wide
echo "
##############################################################################################################
                                    
                                    Bitcoin Wallet Connection Info

    To connect your wallet, you need to first wait for the Bitcoin blockchain to finish syncing. You can 
    inspect the debug.log file (access from Parmanode Bitcoin Core menu) to check its progress in real 
    time. Any errors with Bitcoin Core will show up here as well.

                            s)          Sparrow Bitcoin Wallet

                            e)          Electrum Desktop Wallet

                            sd)         Specter Desktop Wallet

##############################################################################################################
"
choose "xpq"
read choice
set_terminal_wide
case $choice in
    s|S)
    sparrow_wallet_info
    ;;

    e|E)
    electrum_wallet_info
    ;;

    sd|SD|sD|Sd)
    specter_wallet_info
    ;;

    p)
    return 0 ;;

    q|Q|quit|QUIT)
    exit 0
    ;;

    *)
    invalid
    break
    ;;

esac
done
return 0
}



function sparrow_wallet_info {
echo "
##############################################################################################################

                                           SPARROW BITCOIN WALLET

    Unfortunately, for now, this wallet needs to be on the same computer as the Parmanode software.
     
    In the Sparrow Server settings, use 127.0.0.1 as the IP address and 8332 as the port. 
   
    The default connection method in Sparrow uses a cookie. This should work. If it doesn't, you can 
    change to the \"User/Pass\" method, but you do need to enter a rpcuser and rpcpassword in the 
    bitcoin.conf file (accessible through Parmanode menu). You then have to restart bitcoind.
 
    If you ever decided to install Fulcrum (an Electrum server) on your Parmanode, then Sparrow will 
    be able to connect to that instead of directly to Bitcoin Core. If this is enabled, you are not 
    as limited, and can connect from another computer. Fulcrum will be available for Parmanode in 
    later versions. Tor will also be available later, allowing you to connect to your Fulcrum
    Parmanode server from outside your home network.

##############################################################################################################

"
enter_continue
return 0
}

function electrum_wallet_info {
echo "
##############################################################################################################

                                       ELECTRUM DESKTOP WALLET

    Note that a connection with Electrum Wallet is not possible until Fulcrum Server is installed.

    Once Fulcrum is installed, you can connect to it from your Electrum Wallet with the following steps:

        1) Go to Electrum Network settings (from menu or the circle on the bottom right)
	
        2) Uncheck \"Select server automatically\"
	
        3) Type the IP address of the computer that runs Parmanode.
                You can find this by typing \"ifconfig | grep broadcast\" in your terminal window. 
                You'll see it as one of the outputs. Typically something like 192.168.0.150

        4) If the wallet and Parmanode are on the same computer, you can type either
            \"localhost\" or \"127.0.0.1\"
	    
        5) If your wallet is not on the same computer as Parmanode, you need to type the IP address
           of the Parmanode computer in your wallet.

        6) You also MUST type in the port. The default value is 50002. An example would look like:

                                         127.0.0.1:50002
    
    At the top of the network settings window, you will see \"connected to x nodes\". If x is not equal
    to 1, you should try to fix that (f).

    Instructions to connect to Tor soon.

##############################################################################################################

Type (f) for instructions to connect to only one server, or hit <enter> alone to return.

"
read choice
if [[ $choice == "f" ]] ; then electrum_one_server ; fi
return 0

}

function electrum_one_server {
echo "
##############################################################################################################

                                  Connect Electrum to One Server Only

    Unfortunately, this is harder than it needs to be.

    You MUST open a Wallet in Electrum at least once. Even a dummy/discardable wallet will do. This will
    populate a default config file. Then exit Electrum altogether. Shut it down.

    Then navigate to $HOME/.electrum

    Open the file \"config\". You could open via terminal with \"nano config\"

    Modify the line that has \"oneserver\" in it, from \"false\" to \"true\", and do not change the syntax.

    Save and exit. You can then open Electrum Wallet, check the network settings and see that you are only
    connected to one node.

##############################################################################################################
"
enter_continue
return 0
}

function specter_wallet_info {
echo "
##############################################################################################################
                        
                                        Specter Desktop Wallet:

    Newer versions of Specter now allow you to connect not only to Bitcoin Core directly, but to an 
    Electrum (Fulcrum) server as well. 
    
    You need to name the connection to proceed. It's not yet tested, but if it insists on a username and 
    password, you need to modify the bitcoin.conf file (see the Parmanode Bitcoin menu to access) and 
    add it in like this:

                                         rpcuser=my_user_name
                                        
                                         rpcpassword=my_password 
    
    If you make changes to the config file, you need to restart Bitcoin for the changes to take effect.

    In Specter Wallet, you'll see http://localhost - leave as is, but if that doesn't work, try 
    http://127.0.0.1, then finally, click \"Connect\"

##############################################################################################################
"
enter_continue
return 0

}
