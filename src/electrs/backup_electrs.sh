#will just skip this to backup_electrs_do
function backup_electrs {
while true ; do

set_terminal ; echo -e "
########################################################################################

    Now that you've gone through the pain of waiting for electrs to compile, you might
    as well back up the files created and keep a copy somewhere out of the way. That
    way, if you ever uninstall/reinstall, you can get Parmanode to use the backup, and
    copy it to the location needed.

    Back up compiled code?
$green
                y)$orange      Yes! Bloody brilliant
$red
                n)$orange      Nah

########################################################################################
"
choose xmq ; read choice ; set_terminal
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in 
q|Q) exit ;; m|M) back2main ;;
n|N|No|NO|nah|NAH) return 0 ;; 
y|Y|YES|Yes|yes|shit_yeah) backup_electrs_do ; return 0 ;;
*) invalid ;;
esac
done
}

function backup_electrs_do {
please_wait
sudo rm -rf $HOME/.electrs_backup >/dev/null 2>&1
cp -r $HOME/parmanode/electrs/ $HOME/.electrs_backup/
}
