function restore_internal_nostr_data {

file=$HOME/.nostr_data_backup

while true ; do
set_terminal ; echo -e "
########################################################################################

    Would you like to use the backup data directory... 
$cyan

                 $file ?


$pink       y)$orange  Yes please that's outrageously good

$pink       n)$orange  Nah, leave it

$pink       d)$orange  Nah, and get rid of it

########################################################################################
"
choose "xpmq" ; read choice
case $choice in

m|M) back2main ;;
q|Q) exit ;;
p|P) return 1 ;;

y|Y|YES|Yes|yes)
mv $file $HOME/.nostr_data
return 0
;;

n|N|nah) return 0 ;;

d|D|delete) 
please_wait 
rm -rf $file 
return 0
;;

*) invalid ;;
esac
done #end while
}