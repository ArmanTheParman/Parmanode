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

    The node will auto-restart when the computer reboots, but it will fail unless
    you set up auto-unlock for your wallet. You can do that in the Parmanode LND menu.

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
choose xpmq ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
c|C)
channel_info
;;
*) return 0 ;;
esac
}

function channel_info {

set_terminal ; echo -e "
########################################################################################

    When backing up lightning channels, there are two possible avenues.
$cyan
   A)$orange The best way is to back up the$red 'channel.backup'$orange file. This is a static channel
      back up. When you restore your lightning wallet, you'll enter your seed, and 
      this file (when prompted). Your on-chain funds will be restored immediately,
      and the channels you had open will be closed. The funds will first move to a
      sort of trustless 'escrow' address, and after some time of holding, will be
      sent to your lightning wallet (you will receive your share of the funds as per
      the state of the channel, and your channel partner will receive theirs).
$cyan
   B)$orange Another way (not recommended) is to rely of the$red channel.db$orange file to back up. 
      This method allows you to keep your channels open, however, if there is any
      change to the channel state different to that recorded in the channel.db file,
      then your channel partner is entitled to punish you and take all the funds in 
      the channel.$pink Sticking to option A is my suggestion, and that is the only option
      supported by Parmanode.$orange

########################################################################################
"
enter_continue ; jump $enter_cont
}

