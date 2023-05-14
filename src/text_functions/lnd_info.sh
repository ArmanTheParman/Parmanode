function lnd_info {
    set_terminal ; echo "
########################################################################################

                        Important info about using LND

    LND is a bit funny about starting up. If you stop LND, and try to immediately
    restart it, it won't work. There is an intentional delay built in, and there is 
    no warning about it. When you start LND, have a look at the log to make sure it 
    works, and if not have another go in a minute or so.

    Sometimes your wallet may not appear to be loading. It can just be that you need
    to unlock it. Even though your password is saved and the configuration is such
    that the wallet should unlock itself with the saved password, it doesn't always
    happen. You can manually unlock the wallet from the parmanode menu.

    When you first restore a lightning wallet from seed, your balance will show
    zero for a little while, even if you've unlocked it, as the node searches for
    UTXOs in the wallet. Give it some time.

    If your lightning node is important to you, make sure you regularly back up the
    static channel backup file, particularly if you open a new channel.

    Also, if the node is important to you, set up a UPS (Uninterrupted power supply).
    You can buy the on line, and the give your computer some power during a powerout
    and allow you to safely shut the computer down, avoiding data corruption.

########################################################################################
"
enter_continue
}