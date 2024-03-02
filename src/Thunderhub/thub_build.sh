# To build your own docker image with the basePath of your choice you can use docker 
# build --build-arg BASE_PATH='/thub' -t myOwnDockerImage .
# You can run ThunderHub behind a proxy with the following configuration (NGINX example):
#
#     location /thub {
#       proxy_pass http://localhost:3000/thub;
#     }