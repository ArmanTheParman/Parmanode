function change_colours {

while true ; do

#For displaying status in the menu
if grep -q "colourscheme=inverted" $pc ; then
current_inverted="$red Current Selection$orange"
unset current_normal
elif grep -q "colourscheme=normal" $pc ; then
current_normal="$red Current Selection$orange"
unset current_inverted
fi

clear
if [[ -z $1 ]] ; then
echo -e "
########################################################################################

   You can toggle the colour scheme between two options, one of which may look better
   depending on the colour you have set on your Terminal application.
$cyan
            (n)$orange      Normal colours $current_normal
$cyan
            (i)$orange      Inverted colours $current_inverted

########################################################################################
"
choose "xpqm" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
else
choice="$1"
fi

case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
n|normal)
parmanode_conf_remove "orange=" 
parmanode_conf_remove "colourscheme=inverted"
parmanode_conf_add "colourscheme=normal" 
;;
i|inverted)
parmanode_conf_remove "orange=" 
parmanode_conf_add "orange=\"$reset\""
parmanode_conf_remove "colourscheme=normal" 
parmanode_conf_add "colourscheme=inverted"
;;
"")
continue ;;
*) invalid ;;
esac
announce "Please restart Parmanode to see the changes - quit, then 'rp' <enter> at
    the prompt."
done
}