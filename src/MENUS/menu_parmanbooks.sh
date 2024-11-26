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
invalid 
;;

esac
done
return 0
}
