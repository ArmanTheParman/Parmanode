#USAGE:
#exit_choice ; if [[ $? ==1 ]]; then return 1 ; fi 

function exit_choice {
read choice

case $choice in

q|QUIT|Q|quit)
exit 0 ;;

p|P)
return 1 ;;

"")
return 0 ;;

esac
}