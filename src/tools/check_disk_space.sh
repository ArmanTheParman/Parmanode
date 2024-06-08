function check_disk_space {
space_left=$(df | grep -E '\/$' | awk '{print $4}' | tr -d \r)
if [[ $space_left -lt 5000000 ]] ; then #5 Gig

while true ; do
set_terminal ; echo -e "
########################################################################################
$red
    Warning, you have less than 5Gb of drive space on the root file system.
   
    As disk space gets low, some programs will fail to install/work seemingly for no 
    reason. $orange
$green    
    The easiest way to free up space is to use the drive cleanup tool in Parmanode
    (see tools menu).
$orange
    To see some tips to do SOME of it yourself, type$cyan more$orange then $cyan<enter>$orange

    To  run the drive cleanup tool now, type$cyan clean$orange then$cyan <enter>$orange

    Otherwise, just hit$cyan<enter>$orange to continue.

########################################################################################
"
read choice
set_terminal
case $choice in
q|Q) exit ;; p|P|"") return 0 ;;
more) break ;;
clean) free_up_space ;;
*) invalid ;;
esac
done

set_terminal ; echo -e "
########################################################################################

    Some ways to reduce disk space...
$cyan
        docker system prune 
$orange
    Only useful if you have Docker installed and have unused containers and images 
    taking up space; might be worth a try.

    Another thing do is to$green empty the recycle bin.$orange If you aren't using a GUI, 
    you can empty the recycle bin usually kept here:
$cyan
        $HOME/.local/share/Trash
$orange
    You should also clear the package manager cache with:
$cyan
        sudo apt-get clean
$orange
    Another thing you could do is explore the disk. You can use a text base program,
    ncdu, or graphical, 'baobab'. Install either with apt-get isntall command on Linux.
$cyan
        sudo apt-get install baobab 
        sudo apt-get install ncdu $orange
 
########################################################################################
"
enter_continue
fi
}