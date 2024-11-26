function menu_parmanbooks {
while true ; do
set_terminal
echo -ne "
########################################################################################$cyan

                                Parman Books Menu $orange

########################################################################################

"
num=0 
ls $hp/parman_books | while read i ; do 
               num=$((num + 1)) 
               echo -e "$cyan    $num)$orange       $i"
               done
echo -ne "
########################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;

*)
debug "in *"
open_book || invalid
;;

esac
done
return 0
}

function open_book {
num=0 
cd $hp/parman_books
ls | while read x ; do 
    num=$((num + 1)) 
    if [[ $num == $choice ]] ; then
        open "$x"
        return 0
    else
        continue
    fi
return 1
done 
}
