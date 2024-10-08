function change_colours {

while true ; do
clear
echo -e "
########################################################################################

   You can toggle the colour scheme between two options, one of which may look better
   depending on the colour you have set on your Terminal application.
$cyan
            (t)$orange      Toggle colours (requires restarting Parmanode and Terminal)

########################################################################################
"
choose "xpqm"
read choice ; clear
case $choice in
q|Q) exit ;; p|P) return 1 ;;
m|M) back2main ;;
t|T)
if grep -q "orange=" < $pc ; then
parmanode_conf_remove "orange=" 
else
parmanode_conf_add "orange=\"$reset\""
fi
announce "Please restart Parmanode to see the changes."
return 0
;;
*) invalid ;;
esac
done
}