function start_rtl {
if ! docker ps | grep rtl ; then
please_wait
docker start rtl
sleep 4
fi
docker exec -d rtl sh -c "cd /home/parman/RTL && node rtl"
}