function check_disk_space {
space_left=$(df | grep -E '\/$' | awk '{print $4}' | tr -d \r)
if [[ $space_left -lt 5000000 ]] ; then #5 Gig
set_terminal ; echo -e "
########################################################################################
$red
    Warning, you have less than 5Gb of drive space on the root file system.$orange As disk
    space gets low, some programs will fail to install seemingly for no reason.
    
    One way to get rid of data you don't need is to run the command
$cyan
        docker system prune 
$orange
    But this is only true of you have Docker installed and have unused containers and
    images taking up space; might be worth a try.

    Another think do is to$green empty the recycle bin.$orange If you aren't using a GUI, you can
    empty the recycle bin usually kept here:
$cyan
        $HOME/.local/share/Trash
$orange
    Another thing you could do is use the program 'baobab' which is a GUI tool to
    find where your excess data is. Then you can decide if it's deletable. On Linux, 
    get it with:
$cyan
    sudo apt-get install baobab $orange

########################################################################################
"
enter_continue
}