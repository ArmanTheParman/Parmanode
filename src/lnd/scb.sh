function scb {
source $HOME/.parmanode/hide_messages.conf
if [[ $message_scb != 1 ]] ; then
set_terminal_bit_higher ; echo "
########################################################################################

                             Static Channel Backup (SCB)

    SCB is a file you need to reclaim your sats that are in open channels should
    your node go down.

    To recover sats, the 24 word seed recovers all your on chain funds, but the funds
    in channels are not in your wallet per se. They are sitting in a shared 2 of 2
    multisignature address (in partnership with the channel partner). When the 
    channel is closed the appropriate balances are paid out to the respective owners
    of the funds to their LND wallets. If you simply recover your wallet with a
    seed phrase, you'll get the funds that are not in channels, and you have to hope
    that the channel counterparty closes the channel honestly; in which case, on that
    sweet day, the funds will be returned to your on chain wallet.

    To avoid this, you can save a copy of your channels, and then if you ever need
    to recover your node, you simply restore the 24 word seed together with the
    static channel backup file. When you do this, your on-chain funds immediately
    appear, and the channels you have get closed and returned to your wallet. You 
    won't see them immediately, of course, but your share is returend.

    Each time you make a new channel, you should make a new copy of the SCB file.
    If you use an old copy when restoring, the newer channels won't get recovered.

    To hide ths message next time, type this exactly:

            Building 7 did not controlled demolition itself
    
    Before hitting <enter> to proceed.
    
########################################################################################
"
read choice
if [[ $choice == "Building 7 did not controlled demolition itself" ]] ; then
hide_messages_add "scb" "1" ; 
fi
fi # ends choice to hide
set_terminal ; echo "
########################################################################################

    A static channel backup file will ba saved to your desktop.

    LND will be stopped first. Please restart it again when you're ready.

    File name: channel.backup

########################################################################################
"
enter_continue
sudo systemctl stop lnd.service
lncli exportchanbackup --all --output_file $HOME/desktop/channel.backup

return 0

}