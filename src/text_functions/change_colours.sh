function change_colours {

while true ; do
clear
echo -e "
########################################################################################

   The colour scheme of Parmanode may not suite your terminal theme. For example, on
   Macs, if you have a white background, the yellow text will not be easy on the eyes.

   It is recommended you change the terminal to a black background, but alternatively
   parmande can reset the yellow colour to the terminal's default. You'll still get 
   the occasional highlighted/coloured text for emphasis.

   If you want to change the background colour to black instead, just hit Apple and
   the comma symbol together to open preferences, then find the background colour
   option.

   To remove most of the colour from Parmanode, type$cyan "boo"$orange now then hit
   $cyan<enter>$orange.

   Or, to reset back to the default Parmanode colours, type$cyan "yay"$orange then hit
   $cyan<enter>$orange.

########################################################################################
"
choose "xpqm"
read choice ; clear
case $choice in
q|Q) exit ;; p|P) return 1 ;;
m|M) back2main ;;
boo|BOO|Boo)
reset_colour 
announce "Please restart Parmanode to see the changes."
return 0
;;
yay|YAY|Yay)
reset_colour default
announce "Please restart Parmanode to see the changes."
return 0
;;
*) invalid ;;
esac
done
}

function reset_colour {
if [[ $1 == default ]] ; then parmanode_conf_remove "orange=" ; return 0 ; fi
# if no argument...
parmanode_conf_add "orange=\"$reset\""
}