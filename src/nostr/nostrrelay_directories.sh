function nostrrelay_directories {

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


if [[ ! -d /var/www/website ]] ; then
set_terminal
sudo mkdir -p /var/www/website >/dev/null 2>&1
fi

sudo chown -R www-data:www-data /var/www/website
sudo find /var/www/website -type d -exec chmod 755 {} \; >/dev/null 2>&2
sudo find /var/www/website -type f -exec chmod 644 {} \; >/dev/null 2>&2
debug "after permissions"

}