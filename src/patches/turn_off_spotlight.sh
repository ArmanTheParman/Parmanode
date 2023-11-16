function turn_off_spotlight {

if [[ $OS != Mac ]] ; then return 0 ; fi

if sudo mdutil -s $parmanode_drive | grep -q disabled ; then
   return 0
else
   sudo mdutil -i off $parmanode_drive >/dev/null 2>&1
   sudo mdutil -E $parmanode_drive >/dev/null 2&1
fi
}