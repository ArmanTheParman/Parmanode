function fulcrum_database_corrupted {
while true ; do
set_terminal ; echo "
########################################################################################

    Have you noticed from the log menu that Fulcrum's database is corrupted? This
    sometimes happens seemingly for no reason. It's sensitive; kind of ridiculous.

    If this has happened, you need to stop Fulcrum, delete the database, and restart
    Fulcrum - it's unfortunate, but it means starting over. An alternative is to use
    electrs server instead.

    Do you want Parmanode to clean it up and start Fulcrum over for you?

                        y)      Yes, do it, I can't be bothered

                        n)      No, leave it, I'll try to figure it out myself

######################################################################################## 
"
choose "xpmq" ; read choice ; set_terminal
case $choice in
m) back2main ;;
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
    else
         rm -rf $parmanode_drive/fulcrum_db
         sudo mkdir $parmanode_drive/fulcrum_db
    fi
else
    rm -rf $HOME/parmanode/fulcrum_db
    mkdir $HOME/parmanode/fulcrum_db
fi
break
;;
*) invalid
esac
done
}