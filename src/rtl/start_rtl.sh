function start_rtl {
#start podman if it is not running 
if ! podman ps >$dn 2>&1 ; then 
announce "Please make sure Docker is running, then try again. Aborting."
return 1
fi

if ! podman ps | grep rtl ; then
please_wait
podman start rtl
sleep 4
fi
podman exec -d rtl sh -c "cd /home/parman/RTL && node rtl"
}