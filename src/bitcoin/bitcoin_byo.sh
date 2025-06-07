function bitcoin_byo {
set_terminal ; echo -e "
########################################################################################
$cyan
             How to bring in your existing Bitcoin data from another drive.
$orange
    If your data is from Umbrel, Mynode, or RaspiBlitz, then it's better to abort
    and use the custom import drive function.

    To import your exiting Bitcoin data on a non-Parmanode drive, do the following: 
$green
        1)$orange   Label your drive as 'parmanode' - this is important for detection
             and preventing errors later.
        
$green        2)$orange   Make a directory called '.bitcoin' at the root of the drive. Don't
             forget the dot, indicating it's a hidden directory.

$green        3)$orange   Copy your bitcoin data into this directory. If you need help with that
             you probably shouldn't be attempting this. Also, you may consider 
             using the Parmanode rsync helper tool in the Tools menu for reliable 
             copying of data and file attributes; it's also possible to copy the data
             from another computer of SSH using this tool. Do make sure any copying 
             of Bitcoin data happens when Bitcoin itself is not running or the data
             will certainly become corrupted. No joke.              

$green        4)$orange   From this point, repeat the Bitcoin installation and select
             'import Parmanode drive' because that's what it effectively is now.
       
$orange
########################################################################################
"
enter_continue
jump $enter_cont
}
