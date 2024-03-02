function build_thub {
cd $hp/thunderhub
docker build -t thunderhub . | tee -a $dp/thunderhub.log || buildfailed=true
echo "Pausing to check docker biuld"
enter_continue
if [[ $buildfailed == true ]] ; then 
announce "Something went wrong. Aborting."
unset buildfailed ; return 1 ; fi
}
    
    
# To build your own docker image with the basePath of your choice you can use docker 
# build --build-arg BASE_PATH='/thub' -t myOwnDockerImage .
# You can run ThunderHub behind a proxy with the following configuration (NGINX example):
#
#     location /thub {
#       proxy_pass http://localhost:3000/thub;
#     }