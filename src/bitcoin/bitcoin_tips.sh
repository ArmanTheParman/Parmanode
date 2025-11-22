

function bitcoin_tips {
set_terminal_high ; echo -e "
########################################################################################$cyan
                          Parmanode Bitcoin Usage Tips$orange
########################################################################################


    It's nice to see what Bitcoin is up to in real time. Check out the log from the
    menu. If the log menu is playing up, you can look at it manually with $cyan
    nano $HOME/.bitcoin/debug.log$orange

    The information like the block height is captured from the debug.log file. It can
    glitch, no big deal, you can just look at the log and read the progress. The
    file populates with the newest additions at the bottom. When you see$cyan
    progress=1.00000000$orange, you know it's fully synced.

    If you have data corruption, Bitcoin will fail to start. Read the log file and 
    see if it indicates data corruption - you'll have to delete and resync. Parmanode
    Bitcoin menu has a tool for that.

    If you are having trouble starting/stopping bitcoin, you can try doing it manually.
    In Mac, use the GUI - click the icon in the Applications menu. In Linux, do$cyan 
    sudo systemctl COMMAND bitcoind$orange. Replace COMMAND with start, stop, restart, 
    or status.
    
    In you're using the BTCPay combo docker container, restarting the container 
    manually will be problematic, because the numerous programs do not automatically 
    load up if the container is simply restarted. Instead, you can manually enter the 
    container, do$cyan pkill -15 bitcoind$orange, and restart it with
    
        $cyan bitcoind -conf=/home/parman/.bitcoin/bitcoin.conf$orange

    If you want to move the data directory somewhere else, first have a look at the
    ${cyan}dfat$orange menu option in Parmanode-->Tools, and glean from there how the symlinks
    work. To move or copy the data directory, make sure Bitcoin has been stopped. Then
    use the$cyan rysync$orange tool from the Parmanode-->Tools menu. It will help you 
    construct the correct command.


########################################################################################
"
choose xpmq ; read choice
jump $choice || { invalid ; continue ; }
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
*)
return 0 
;;
esac

}