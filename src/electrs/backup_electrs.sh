function backup_electrs {
while true ; do

set_terminal ; echo -e "
########################################################################################

    Now that you've gone through the pain of waiting for electrs to compile, you might
    as well back up the files created and keep a copy somewhere out of the way. That
    way, if you ever uninstall/reinstall, you can get Parmanode to use the backup, and
    copy it to the location needed.
$cyan
    Back up compiled code?
$orange
                y)      Yes. Brilliant.

                n)      Nah

########################################################################################
"
read choice
set_terminal

case $choice in 
n|N|No|NO|nah|NAH) return 0 ;;
y|Y|YES|Yes|yes|shit_yeah) 
backup_electrs_do ; return 0 ;;
*) invalid ;;
esac
done
}

function backup_electrs_do {
please_wait
rm -rf $HOME/.electrs_backup >/dev/null 2>&1
cp -r $HOME/parmanode/electrs/ $HOME/.electrs_backup/
}
