function install_thunderhub {
export version="v0.13.30"
export thub_port="2999"
#check port with netstat -tulnp


#make sure bitcoin installed
#make sure lightning running
#make sure docker installed
if ! which docker >/dev/null 2>&1 ; then announce "Please install Docker first." ; return 1 ; fi

 #git clone --depth 1 https://github.com/apotdevin/thunderhub.git

#docker install
docker pull apotdevin/thunderhub:$version
docker run --rm -d -p $thub_port:3000/tcp apotdevin/thunderhub:$version


installed_conf_add "thunderhub-start"

}