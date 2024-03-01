function install_thunderhub {

#make sure bitcoin installed
#make sure lightning running
#make sure docker installed
if ! which docker >/dev/null 2>&1 ; then announce "Please install Docker first." ; return 1 ; fi

 #git clone --depth 1 https://github.com/apotdevin/thunderhub.git

#docker install
docker pull apotdevin/thunderhub:v0.13.30
docker run --rm -d -p 2999:3000/tcp apotdevin/thunderhub:v0.5.5

#https://docs.thunderhub.io/setup#server-accounts

installed_conf_add "thunderhub-start"

}