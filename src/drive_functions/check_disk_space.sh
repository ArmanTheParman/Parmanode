function check_disk_space {
space_left=$(df | grep -E '\/$' | awk '{print $4}' | tr -d \r)
if [[ $space_left -lt 5000000 ]] ; then #5 Gig
set_terminal ; echo -e "
########################################################################################
$red
    Warning, you have less than 5Gb of drive space on the root file system.
   
    As disk space gets low, some programs will fail to install/work seemingly for no 
    reason. $orange
    
    The easiest way to free up space is to use the drive cleanup tool in Parmanode
    (see tools menu).
    
    Another way is to run the command:
$cyan
        docker system prune 
$orange
    But this is only true of you have Docker installed and have unused containers and
    images taking up space; might be worth a try.

    Another thing do is to$green empty the recycle bin.$orange If you aren't using a GUI, you can
    empty the recycle bin usually kept here:
$cyan
        $HOME/.local/share/Trash
$orange
    Another thing you could do is use the program 'baobab' which is a GUI tool to
    find where your excess data is. Then you can decide if it's deletable. It won't
    work over SSH by the way. On Linux, get it with:
$cyan
        sudo apt-get install baobab $orange
 
########################################################################################
"
enter_continue
fi
}