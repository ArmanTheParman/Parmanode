function nostr_data_exists_or_create {
#internal or external
unset file

if [[ $drive_nostr == external ]] ; then
file=$pd/nostr_data
elif [[ $drive_nostr == internal ]] ; then
file=$HOME/.nostr_data
elif [[ $drive_nostr == custom ]] ; then
file=$drive_nostr_custom_data
return 0
fi

if [[ -e $file ]] ; then
debug "file is $file"
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
    $file$orange already exists. What is to be done?
$cyan
        1)$orange    Delete the data and start over
$cyan
        2)$orange    Use the data
$cyan
        3)$orange    Back up the data to ${file}_bakup_$(date +'%Y-%m-%d')
              and start over

########################################################################################
"
choose xpmq ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
1)
sudo rm -rf $file
mkdir $file
break
;;
2)
break
;;
3)
mv $file ${file}_backup_$(date +'%Y-%m-%d')
mkdir $file
break
;;
*)
invalid 
;;
esac
done
else
mkdir $file
fi

}