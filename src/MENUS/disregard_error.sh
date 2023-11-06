function disregard_error {

while true ; do
set_terminal
echo -e "
########################################################################################
$cyan
                  Would you like to disregard the error and push on?
$orange

           $green yolo) $orange       Yeah, disregard. What could go wrong?

           $red  n) $orange          Abort

########################################################################################
"
choose "xq"
read choice
case $choice in

q|Q) exit ;;
n|N|NO|No|no) return 1 ;;
yolo|YOLO|Yolo) return 0 ;;
*) invalid ;;

esac
done

}