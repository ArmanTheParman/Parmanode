function menu_settings {
while true ; do
source $hm >/dev/null 2>&1 #hide messages
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
case $choice in 
m|M) back2main ;;
Q|q|QUIT|Quit|quit) exit 0 ;; 
p|P) return ;;
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