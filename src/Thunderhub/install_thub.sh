function install_thunderhub {
export version="v0.13.30"
export thub_port="2999"
export file=$hp/thunderhub/.env.local #adding '.local' prevents overriding file when updating.


set_terminal ; echo -e "
########################################################################################

    Parmanode will help yo uinstall$cyan Thunderhub$orange and ask you some questions to 
    configure it.

########################################################################################
"
enter_continue 

#check port with netstat -tulnp
while true ; do
{ netstat -tuln | grep -q :2999 && break ; } || export thub_port="2998"
{ netstat -tuln | grep -q :2998 && break ; } || export thub_port="2997"
{ netstat -tuln | grep -q :2997 && break ; } || export thub_port="2996"
{ netstat -tuln | grep -q :2996 && break ; } || export thub_port="2995"
announce "Unable to find a free port between 2995 and 2999 inclusive. Aborting." && return 1
done

#make sure bitcoin installed
if ! grep -q "bitcoin-end" < $ic >/dev/null 2>&1 ; then
announce "Please install Bitcoin first. Aborting."
return 1
fi

#make sure lightning installed 
if ! grep -q "lnd-end" < $ic >/dev/null 2>&1 ; then
announce "Please install LND first. Aborting."
return 1
fi

#make sure docker installed
if ! which docker >/dev/null 2>&1 ; then 
announce "Please install Docker first. Aborting." 
return 1 
fi

cd $hp
git clone --depth 1 https://github.com/apotdevin/thunderhub.git
cd thunderhub

make_thub_env || return 1
master_password_thub || return 1



# #docker install
# docker pull apotdevin/thunderhub:$version
# docker run --rm -d -p $thub_port:3000/tcp apotdevin/thunderhub:$version


installed_conf_add "thunderhub-start"

}

