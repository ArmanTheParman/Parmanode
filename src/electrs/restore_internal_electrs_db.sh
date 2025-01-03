function restore_internal_electrs_db {
#offers to restore an internal drive backup if found


file="$hp/electrs/electrs_db" #this is the old internal location, necessary to leave for this function.
file2="$hp/electrs_db_backup"
file3="$HOME/.electrs_db_backup"
unset found message

for file in $file $file2 $file3 ; do
if [[ ! -e $file ]] ; then continue ; else 

    if [[ -n $found ]] ; then
message="$pink 
    Another backup directory has been found. $orange
"
    fi
found="true" 
fi 


while true ; do
set_terminal ; echo -e "
########################################################################################
    $message
    Would you like to use the backup data directory... 
$cyan
                 $file ?


$pink       y)$orange  Yes please that's outrageously good

$pink       n)$orange  Nah, leave it

$pink       d)$orange  Nah, and get rid of it

########################################################################################
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
n|N|nah) return 0 ;;
d|D|delete) 
please_wait 
sudo rm -rf $file 
return 0
;;
y|Y|YES|Yes|yes)
if [[ -d $HOME/.electrs_db ]] ; then
while true ; do
set_terminal ; echo -e "
########################################################################################
    Parmanode was about to move the backed up database directory 

    $yello$file$orange 
    
       to  $cyan

    $HOME/.electrs_db$orange but that directory already exists.
$red
     a)    Abort, Abort ! 
$pink
     b)    Do it anyway, I don't care if I lose what's in $HOME/.electrs_db
$green    
     c)    Abandon the move and just use whats in $HOME/.electrs_db
$orange
########################################################################################    
" ; choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit 0 ;; p|P) return 1 ;; m|M|a) back2main ;;
b)
please_wait
sudo rm -rf $HOME/.electrs_db
mv $file $HOME/.electrs_db 
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