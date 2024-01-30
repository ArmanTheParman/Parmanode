function info_electrs {

set_terminal ; echo "
########################################################################################

    Raspberry Pi issues:
        
        Electrs will install on a Raspberry Pi, but after the long wait syncing, I
        experienced great difficulty connecting wallets to the server, either on
        the same device or from a different device - be warned. It is probaby better
        that for Raspberry Pi, you install the Docker version of Electrs, which I 
        found to work well.

        It is possible that when you inspect the log file, you'll see electrs starting
        and then terminating, and after some time starting again and failing again.

        I have observed this while testing on a Raspberry Pi 64-bit, but it works fine
        on a Linux AMD 64 bit desktop computer.

        The problem resolved on its own after an hour or so, and may do the same for 
        you, just a warning and hint.

        Until some fix is released by the developer of electrs or Bitcoin, this will 
        have to do I'm afraid. 

        Testing on an Intel i5 desktop computer running Linux Mint works completely 
        fine.

########################################################################################
"
enter_continue

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