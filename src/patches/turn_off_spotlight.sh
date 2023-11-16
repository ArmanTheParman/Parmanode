function turn_off_spotlight {

if [[ $OS != Mac ]] ; then return 0 ; fi

if sudo mdutil -s $parmanode_drive | grep -q disabled ; then #checks status of spotlight on drive
   return 0
else
   sudo mdutil -i off $parmanode_drive >/dev/null 2>&1 #turns off spotlight
   sudo mdutil -E $parmanode_drive >/dev/null 2>&1 #erase existing spotlight index
fi
}