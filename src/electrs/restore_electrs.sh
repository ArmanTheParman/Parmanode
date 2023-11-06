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

    If the backup is an old version, and you want a new version, you'll have to choose
    to compile again now, of course. 


                            u)       Use backup of compiled software

                            c)       Compile again


########################################################################################
"
choose "xpmq" ; read choice ; set_terminal

case $choice in
m|M) back2main ;;
q|Q) exit 0 ;;
p|P) return 1 ;;
u|U|use|Use) 
export electrs_compile="false" && return 0 ;;
c|C|compile) 
export electrs_compile="true" && return 0 ;;
*) invalid ;;
esac
done

else
export electrs_compile="true" 
fi
}