function run_rtl {

docker exec -d rtl cd RTL && node rtl >/home/parman/.parmanode/rtldocker.log
}