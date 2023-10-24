function are_you_sure {
while true ; do
set_terminal ; echo -e "$red
########################################################################################

        $1

        ARE YOU SURE ??              y   or   n       then <enter>

########################################################################################
$orange"
read choice
case $choice in 
q|Q) exit ;;
p|P|n|N|NO|No|no) return 1 ;;
y|Yes|YES|Y|yes) return 0 ;;
*) invalid
esac
done
}