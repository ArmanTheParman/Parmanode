function patch_7 {

#log file location has changed, delete the old one.
if grep -q "electrsdkr" $ic ; then
restart_electrs
docker exec -d electrs /bin/bash -c "rm /home/parman/run_electrs.log"
fi
}