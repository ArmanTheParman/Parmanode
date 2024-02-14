function restore_internal_electrumx_db {

file="$HOME/.electrumx_db_backup"
unset found message

if [[ -e $file ]] ; then

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
n|N|nah) return 0 ;;
d|D|delete) 
please_wait 
rm -rf $file 
return 0
;;
y|Y|YES|Yes|yes)
if [[ -d $HOME/.electrumx_db ]] ; then
while true ; do
set_terminal ; echo -e "
########################################################################################
    Parmanode was about to move the backed up database directory 

    $yello$file$orange 
    
       to  $cyan

    $HOME/.electrumx_db$orange but that directory already exists.
$red
     a)    Abort, Abort ! 
$pink
     b)    Do it anyway, I don't care if I lose what's in $HOME/.electrumx_db
$green    
     c)    Abandon the move and just use whats in $HOME/.electrumx_db
$orange
########################################################################################    
" ; choose "xpmq" ; read choice ; clear
case $choice in
q|Q) exit 0 ;; p|P) return 1 ;; m|M|a) back2main ;;
b)
please_wait
rm -rf $HOME/.electrumx_db
mv $file $HOME/.electrumx_db 
return 0
;;
c)
return 0
;;
*) invalid ;;
esac
done
else
   mv $file $HOME/
fi
;;

*) invalid ;;
esac
done #end while
done #end for
}