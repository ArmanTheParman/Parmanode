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
                        y)      Yes, do it, I can't be bothered
$orange
                        n)      No, leave it, I'll try to figure it out myself

######################################################################################## 
"
choose "xpmq" ; read choice ; set_terminal
case $choice in
m|M) back2main ;;
q|Q) exit 0 ;;
p|P) return 0 ;;
n|N|NO|No|no) return 0 ;;
y|Y|YES|Yes|yes) 

if [[ $OS == Mac ]] ; then stop_fulcrum_docker 
else
stop_fulcrum_linux
fi

if [[ $drive_fulcrum == external ]] ; then 
    if [[ $OS == Linux ]] ; then 
         sudo rm -rf $parmanode_drive/fulcrum_db  
         sudo mkdir $parmanode_drive/fulcrum_db
         sudo chown -R $USER:$(id -gn) $parmanode_drive/fulcrum_db
         debug "wait"
    else
         rm -rf $parmanode_drive/fulcrum_db
         sudo mkdir $parmanode_drive/fulcrum_db
         sudo chown -R $USER:$(id -gn) $parmanode_drive/fulcrum_db
    fi
else
    rm -rf $HOME/.fulcrum_db
    rm -rf $HOME/parmanode/fulcrum_db #old location of database (previous versions)
    gsed -i "/datadir =/c\datadir = $HOME/.fulcrum_db" $fc
    mkdir $HOME/.fulcrum_db
fi
break
;;
*) invalid
esac
done
}