function restore_electrs {

if [ -d $HOME/.electrs_backup ] ; then

while true ; do
set_terminal
echo "
########################################################################################

    Parmanode has detected that you've previously compiled and backup up electrs.

    To save time, would you like to use that backup or comile electrs all over again.

    If that was an old version, you'll need to compile again instead, to get the new
    version, of course. 

                       u)    Use backup

                       c)    Compile again

########################################################################################
"
choose "xpq" ; read choice ; set_terminal

case $choice in
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