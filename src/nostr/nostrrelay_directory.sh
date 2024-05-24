function nostrrelay_directory {

if [[ -e $HOME/.nostr_data ]] ; then
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
    $HOME/.nostr_data$orange already exists. What is to be done?

        1)    Delete the data and start over

        2)    Use the data

        3)    Back up the data to $HOME/.nostr_data_backup_$(date +'%Y-%m-%d')
              and start over

########################################################################################
"
choose xpmq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;;
1)
rm -rf $HOME/.nostr_data
mkdir $HOME/.nostr_data
break
;;
2)
break
;;
3)
mv $HOME/.nostr_data $HOME/.nostr_data_backup_$(date +'%Y-%m-%d')
mkdir $HOME/.nostr_data
break
;;
*)
invalid 
;;
esac
done
else
mkdir $HOME/.nostr_data
fi

}