function lnd_info {
    set_terminal ; echo -e "
########################################################################################
$cyan
                        Important info about using LND
$orange

    You must create a wallet for Lightning to work. The seed is printed on the screen
    when you create it - I know, that's insane, but that's the way it is for now.

    Treat your LND wallet very differently to your main stack. It's a HOT wallet,
    not as secure because your seed is exposed to an internet connected computer. LN
    funds are for spending, not for keeping your life savings. Be warned.

    Also, if you have channels open, you need to back them up with a channel backup
    file - the seed is not enough. Learn more about this before opening channels
    containing significant value.

    When you first restore a lightning wallet from seed, your balance will show
    zero for a little while, even if you've unlocked it, as the node searches for
    UTXOs in the wallet. Give it some time.

    Also, if the node is important to you, set up a UPS (Uninterrupted power supply).
    You can buy the on line, and the give your computer some power during a powerout
    and allow you to safely shut the computer down, avoiding data corruption.

    TROUBLESHOOTING
    
        If you are having issues with LND, try uninstalling and reinstalling using
        Parmanode.
$green
    TYPE c TO LEARN ABOUT CHANNEL BACKUPS, THEN <ENTER> OR JUST <ENTER> TO RETURN  
$orange
########################################################################################
"
read choice
if [[ $choice == c || $choice == C ]] ; then
channel_info
else
return 0
fi
}

function channel_info {

set_terminal ; echo "
########################################################################################

    When backing up lightning channels, there are two possible avenues.

   A) The best way is to back up the \"channel.backup\" file. This is a static channel
      back up. When you restore your lightning wallet, you'll enter your seed, and 
      this file (when prompted). Your on-chain funds will be restored immediately,
      and the channels you had open will be closed. The funds will first move to a
      sort of trustless \"escrow\" address, and after some time of holding, will be
      sent to your lightning wallet (you will receive your share of the funds as per
      the state of the channel, and your channel partner will receive theirs).

   B) Another way (not recommended) is to rely of the channel.db file to back up. 
      This method allows you to keep your channels open, however, if there is any
      change to the channel state different to that recorded in the channel.db file,
      then your channel partner is entitled to punish you and take all the funds in 
      the channel. Sticking to option A is my suggestion, and that is the only option
      supported by Parmanode.

########################################################################################

"
enter_continue
}

