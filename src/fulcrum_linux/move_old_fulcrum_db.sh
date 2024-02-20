function move_old_fulcrum_db {
#move internal db drive from old installation if it exists, and destination doesn't
while true ; do
if [[ -d $HOME/parmanode/fulcrum_db ]] ; then

    #first check move destination exists, if it's small, get rid of it 
    if [[ -d $HOME/.fulcrum_db && $(du -s $HOME/.fulcrum_db | grep -Eo '[0-9]+') -lt 10000 ]] ; then

        rm -rf $HOME/.fulcrum_db

    else
    #the directory is not small so not moving anything
    break 
    fi

    #destination dir doesn't exist or was just delteed, so make move... 
    please_wait
    sudo mv $HOME/parmanode/fulcrum_db $HOME/.fulcrum_db >/dev/null 2>&1
    break
fi
#no source to move, so exit
break
done
}