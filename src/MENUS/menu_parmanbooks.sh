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
open_book || continue
menu_main
;;

esac
done
return 0
}

function open_book {
debug "in open book"
num=0 
ls $hp/parman_books | while read i ; do 
    num=$((num + 1)) ; if [[ $num == $choice ]] ; then
        echo "${hp}/${i}"
        read
        #open "${hp}/${i}"
        echo "pause" ; read
        return 0
    else
        echo "$i"
        read
        continue
    fi

    invalid
    return 1
done
debug "end of open book"
}
