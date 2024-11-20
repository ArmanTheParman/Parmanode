function fulcrum_database_corrupted {
while true ; do
set_terminal ; echo -e "
########################################################################################

    Have you noticed from the log menu that Fulcrum's database is corrupted? This
    sometimes happens seemingly for no reason. It's sensitive; kind of ridiculous.

    To fix it, you need to stop Fulcrum, delete the database, and restart
    Fulcrum - it's unfortunate, but it means starting over. An alternative is to use
    electrs or Electrum X server instead.

    Do you want Parmanode to clean it up and start Fulcrum over for you?
$green
                        y)$orange      Yes, do it, I can't be bothered
$red
                        n) $orange     No, leave it, I'll try to figure it out myself

######################################################################################## 
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
m|M) back2main ;; q|Q) exit 0 ;; p|P) return 0 ;;
n|N|NO|No|no) return 0 ;;
y|Y|YES|Yes|yes) 
please_wait
stop_fulcrum

if [[ $drive_fulcrum == external && -e $pd/fulcrum_db ]] ; then 
    rm -rf $pd/fulcrum_db/*
    sudo mkdir -p $pd/fulcrum_db
    sudo chown -R $USER:$(id -gn) $pd/fulcrum_db
elif [[ $drive_fulcrum == internal ]] ; then
    rm -rf $HOME/.fulcrum_db/* 2>$dn
    rm -rf $HOME/parmanode/fulcrum_db 2>$dn #old location of database (previous versions)
fi

break
;;
*) invalid
esac
done
}