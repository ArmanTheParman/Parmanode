function info_electrs_docker {


set_terminal ; echo "
########################################################################################

    Connectivity:

        Electrum wallet works perfectly fine with electrs, but for best results in
        terms of connectivity, you should run Electrum using the Parmanode menu.

        Sometimes, for absoutely no apparant reason, the wallet won't connect but 
        restarting the wallet fixes it. Go figure; computers.

    Sparrow Wallet:

        Sparrow wallet will connect via TCP, but not SSL - sorry, I can't figure out
        why. If you specifically want an SSL connection using Sparrow, then run
        Fulcrum instead of electrs; that works.
    
    Ports:

        Because Parmamnode supports both Fulcrum AND electrs as "Electrum Servers",
        the typical ports 50001 and 50002 has been reserved for Fulcrum, and 
        50005/50006 is used for electrs. This is to avoid any port conflicts.

########################################################################################
"
enter_continue

}