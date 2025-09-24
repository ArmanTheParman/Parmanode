function restore_electrs {

if [ -d $HOME/.electrs_backup ] ; then

while true ; do
set_terminal
echo -e "
########################################################################################
$cyan
    GREAT NEWS!
$orange
    Parmanode has detected that you've previously compiled and backed up electrs.

    To save time, would you like to use that backup (yay), or compile electrs all 
    over again (boo).
$red
    BE AWARE THAT IF THIS BACKUP IS OF AN OLD VERSION, YOU'LL BE INSTALLING THE
    OLD VERSION.$orange

    If the backup is an old version, and you want a new version, you'll have to choose
    to compile again now, of course. 

$green
                      bk)$orange             Use backup of compiled software
$red
                      compile)$orange       Compile again
$cyan
                      del)$orange           Compile again, but delete the backup too

########################################################################################
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
bk)
export electrs_compile="false" && return 0 ;;
compile) 
export electrs_compile="true" && return 0 ;;
del)
sudo rm -rf $HOME/.electrs_backup >$dn 2>&1
export electrs_compile="true" && return 0 ;;
*) invalid ;;
esac
done

else
export electrs_compile="true" 
fi
}