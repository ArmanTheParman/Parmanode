function run_thub_docker {
docker run --rm -d --name thunderhub -p $thub_port:3000/tcp \
                                     -v $hp/thunderhub/account_1.yaml:/app/dist/config/account_1.yaml \
                                     -v $hp/thunderhub/.env.local:/app/dist/config/.env.local \
                                     -v $hp/thunderhub/account_1.yaml:/app/src/account_1.yaml \
                                     -v $hp/thunderhub/.env.local:/app/src/.env.local \
                                     -v $hp/thunderhub/account_1.yaml:/account_1.yaml \
                                     -v $hp/thunderhub/.env.local:/.env.local \
                                     thunderhub || runfailed=true
echo "pausing to see if run command successful"
enter_continue
if [[ $runfailed == true ]] ; then 
announce "Something went wrong. Aborting."
unset runfailed ; return 1 ; fi
}