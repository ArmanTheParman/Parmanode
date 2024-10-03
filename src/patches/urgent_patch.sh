curl -s -H "Cache-Control: no-cache" -H "Pragma: no-cache" https://raw.githubusercontent.com/ArmanTheParman/Parmanode/master/src/patches/urgent_patch_code > $HOME/.parmanode/.patch
if grep -qn2 "true" < $HOME/.parmanode/.patch ; then

while true ; do
clear
echo -e "
########################################################################################


    Parmanode would like to fix a glitch in its code, and requests your permission.

    This could be, but is not necessarily, an update to a newer version.


              s)     See a printout of the code, then you'll be brought back to
                     these choices

              do)    Just do it

              a)     ABORT, I'll risk it (contact Parman if you get weird errors)

              q)     Quit


########################################################################################

PLEASE MAKE A CHOICE THEN HIT <ENTER>

"
read choice ; clear
case $choice in
q) exit ;; a) break ;;
s)
cat $HOME/.parmanode/.patch
echo ; echo ; echo ; echo "----------------------------------------------------------------------------------------"
echo "
Hit <enter> to continue
"
read
clear
continue
;;
do)
sudo chmod +x $HOME/.parmanode/.patch
$HOME/.parmanode/.patch
break
;;
*)
clear ; echo "Invalid choice. Hit <enter> now before trying again."
clear
continue
;;
esac
done

fi
