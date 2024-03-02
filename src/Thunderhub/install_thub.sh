function install_thunderhub {
export version="v0.13.30"
export file=$hp/thunderhub/.env.local #adding '.local' prevents overriding file when updating.


#check port with netstat -tulnp
while true ; do
export thub_port="2999"
{ netstat -tuln | grep -q :2999 && break ; } || export thub_port="2998" && break
{ netstat -tuln | grep -q :2998 && break ; } || export thub_port="2997" && break 
{ netstat -tuln | grep -q :2997 && break ; } || export thub_port="2996" && break  
{ netstat -tuln | grep -q :2996 && break ; } || export thub_port="2995" && break
announce "Unable to find a free port between 2995 and 2999 inclusive. Aborting." && return 1
done
parmanode_conf_add "thub_port=$thub_port"

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
installed_conf_add "thunderhub-start"

make_thub_env || return 1
build_thub || return 1 
run_thub_docker || return 1

installed_conf_add "thunderhub-end"
success "Thunderhub has finished being installed"
}

