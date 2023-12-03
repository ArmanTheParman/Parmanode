function menu_bitcoin_other {
while true
do
set_terminal
source ~/.parmanode/parmanode.conf >/dev/null #get drive variable

unset running output1 output2 
if [[ $OS == Mac ]] ; then
    if pgrep Bitcoin-Q >/dev/null ; then running=true ; else running=false ; fi
else
    if ! ps -x | grep bitcoind | grep -q "bitcoin.conf" >/dev/null 2>&1 ; then running=false ; fi
    if tail -n 1 $HOME/.bitcoin/debug.log | grep -q  "Shutdown: done" ; then running=false ; fi 2>/dev/null
    if pgrep bitcoind >/dev/null 2>&1 ; then running=true ; fi
fi


if [[ $bitcoinrunning != false ]] ; then running=true ; fi

if [[ $bitcoinrunning == true ]] ; then
output1="                   Bitcoin is$green RUNNING$orange-- see log menu for progress"

output2="                         (Syncing to the $drive drive)"
else
output1="                   Bitcoin is$red NOT running$orange -- choose \"start\" to run"

output2="                         (Will sync to the $drive drive)"
fi                         

echo -e "
########################################################################################
                            ${cyan}Bitcoin Core Menu - OTHER ${orange}                               
########################################################################################
"
echo -e "$output1"
echo ""
echo -e "$output2"
echo ""
echo -e "


      (cd)       Change syncing drive internal vs external

      (mp)       Modify Pruning

      (c)        How to connect your wallet...........(Otherwise no point to this)

      (dd)       Backup/Restore data directory.................(Instructions only)
       
      (r)        Errors? Try --reindex blockchain...

      (h)        Hack Parmanode; tips for troubleshooting.

########################################################################################
"
choose "xpmq" ; read choice ; set_terminal

case $choice in
m|M) back2main ;;

cd|CD|Cd)
change_bitcoin_drive
return 0
;;

mp|MP)
modify_prune
;;

c|C)
connect_wallet_info
continue
;;

dd|DD)
echo "
########################################################################################
    
                          BACKUP BITCOIN DATA DIRECTORY    

    If you have a spare drive, it is a good idea to make a copy of the bitcoin data 
    directory from time to time. This could save you waiting a long time if you were 
    ever to experience data corruption and needed to resync the blockchain.

    It is VITAL that you stop bitcoind before copying the data, otherwise it will not 
    work correctly when it comes time toRU|Ru)
    umbrel_import_reverse
    ;; use the backed up data, and it's likely the 
    directory will become corrupted. You have been warned.

    You can copy the entire bitcoin_data directory.

    You could also just copy the chainstate directory, which is a lot smaller, and 
    this could be all that you need should there be a chainstate error one day. This 
    directory is smaller and it's more feasible to back it up frequently. I would 
    suggest doing it every 100,000 blocks or so, in addition to having a full copy 
    backed up if you have drive space somewhere.

    To copy the data, use your usual computer skills to copy files. The directory is 
    located either on the internal drive:

                        $HOME/.bitcoin

    or external drive:

                LINUX :   /media/$(whoami)/parmanode/.bitcoin 
                MAC   :   /Volumes/parmanode/.bitcoin

    Note that if you have an external drive for Parmanode, the internal directory 
    $HOME/.bitcoin is actually a symlink (shortcut) to the external 
    directory.

########################################################################################
"
enter_continue
continue
;;

r|R|reindex)
reindex_bitcoin
return 0
;;

h)
hack_tips
;;

p|P)
return 1
;;

q|Q|Quit|QUIT)
exit 0
;;

*)
invalid
continue
;;

esac

done
return 0
}

function hack_tips {

set_terminal_custom 55 ; echo -e "
########################################################################################

    If for some reason, Bitcoin is not syncing to the correct drive, here's what's
    happening under the hood to help you tweak it.

       1)   Bitcoin Core by default syncs to $green$HOME/.bitcoin$orange, unless specified
            otherwise in bitcoin.conf (default location is different for Macs).

       2)   Parmanode never changes this default directory, instead it 'tricks' 
            Bitcoin Core. For External drives, Parmanode will put a symlink (shortcut)
            at the location of $green$HOME/.bitcoin$orange, pointing to the external drive 
            directory which is$orange /media/$USER/parmanode/.bitcoin$orange for Linux and 
            $green /Volumes/parmanode/.bitcoin$orange for Macs.

       3)   For Macs, the default location for Bitcoin's data on the internal drive
            is strange and long (even worse in Windows), and for simplicity, I've made 
            it point to $green$HOME/.bitcoin$orange on Macs. From there, if a Mac user 
            chooses or switches to the external drive, then 
            $green$HOME/.bitcoin$orange also becomes a symlink, pointing to the 
            external drive. It's beautiful, right? I think it is.
       
       3)   If you look for the .bitcoin directory, you woni't normally see it unless
            you know the tricks to show hidden files/directories (ask Google or 
            ChatGPT if you need help).

       4)   Parmanode signals to itself what kind of drive (internal/external) 
            Bitcoin is syncing to by writing the line 'drive=external' or
            'drive=internal' in the file$green $dp/parmanode.conf$orange

       5)   If after you do some non-standard adjustments, Parmanode has got it wrong, 
            you can add the necessary line to the parmanode.conf file. This will help
            the Parmanode menu's display correctly, and any other alerts/checks to
            work properly.

       6)   Parmanode also adds a line about the drive in the$red /etc/fstab$orange file on
            Linux machines. This is part of the 'import' process, so that the drive
            always mounts when you reboot the computer, and Bitcoin Core can
            start up properly.$red I strongly recommend you don't fiddle with this file
         $orange   unless youo are a super expert, because it can brick your OS if you get
            it wrong. 

########################################################################################
"
enter_continue
return 0
}