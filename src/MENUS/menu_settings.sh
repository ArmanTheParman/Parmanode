function menu_settings {
while true ; do
debug "in settings"
set_terminal ; echo -ne "
########################################################################################$cyan
                                   SETTINGS    $orange
########################################################################################

$cyan
                       (c)$orange         Change Parmanode colours
$cyan
                       (an)$orange        Hide/Show Main Menu announcements
$cyan
                       (aa)$orange        Turn on/off autoupdates

######################################################################################## 
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in 
q|Q) exit ;; p|P|"") return 1 ;; m|M) back2main ;;
c|C) change_colours ; return 0 ;;
an)
if [[ $announcements == off ]] ; then
sudo gsed -i "/announcements=/d" $hm 
echo "announcements=on" | tee -a $hm 
else
sudo gsed -i "/announcements=/d" $hm 
echo "announcements=off" | tee -a $hm
fi
;;
aa|AA|Aa)
autoupdate_toggle
;;
*) invalid ;;
esac
done
}