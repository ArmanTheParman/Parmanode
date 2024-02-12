function info_electrs {


set_terminal ; echo -e "
########################################################################################
$cyan
    Connectivity:
$orange
        For best results in terms of connectivity, you should run your wallets using 
        the Parmanode menu.

        Sometimes, for absoutely no apparant reason, the wallet won't connect but 
        restarting the wallet fixes it. Go figure; computers. Sometimes, restarting
        electrs is needed. Sometimes, you need to delete the connections settings. 
        Use the Parmanode menu option for that.
$cyan
    Sparrow Wallet:
$orange
        Sparrow wallet will connect via TCP, but not SSL - sorry, I can't figure out
        why, I'll fix it later. If you specifically want an SSL connection using 
        Sparrow, then run Fulcrum instead of electrs; that works, but there's no need.
$cyan
    Ports:
$orange
        Because Parmamnode supports both Fulcrum AND electrs as "Electrum Servers",
        the typical ports 50001 and 50002 has been reserved for Fulcrum, and 
        50005/50006 is used for electrs. This is to avoid any port conflicts.
$cyan
    Tor:
$orange
        Connecting over Tor allows you to connect from anywayer. It's not about privacy
        per se, because when you connect to your own node, only you will know about it.
        Your network communication is not leaked to the internet.

        If running electrs in Docker, there is a Tor server that Parmanode has added
        for you. To access it, use port 9060. If you ahve Tor on your system, you 
        would use port 9050 for a daemon (backgroun Tor) and 9150 if using Tor browser
        as the Tor engine. Later, I'll make a seperate Tor container, but the port will
        remain as 9060.

########################################################################################
"
enter_continue

}