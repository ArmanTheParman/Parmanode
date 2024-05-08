function start_rtl {
#start docker if it is not running 
if ! docker ps >/dev/null 2>&1 ; then 
announce "Please make sure Docker is running, then try again. Aborting."
return 1
fi

if ! docker ps | grep rtl ; then
please_wait
docker start rtl
sleep 4
fi
docker exec -d rtl sh -c "cd /home/parman/RTL && node rtl"
}