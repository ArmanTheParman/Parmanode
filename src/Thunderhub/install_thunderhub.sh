function install_thunderhub {

### Needs to check for xxd ***
if ! which xxd >$dn 2>&1 ; then 
if [[ $OS == Linux ]] ; then
set_terminal ; echo -e "$green
Installing dependecies...

xxd
"
sleep 1
sudo apt-get update -y && export APT_UPDATE="true" && sudo apt-get install xxd -y 
fi

if [[ $OS == "Mac" ]] ; then announce "Mac needs xxd to be installed to continue. Please
    do that somehow. Usually installing command line tools is sufficient, and Parmanode
    would have attempted to do this when you first installed Parmanode. Contact the 
    internet or Parman for help to install xxd. Aborting."
return 1 
fi
fi #end if no xxd

##############################

set_terminal
export version="$thunderhub_version"
# export file=$hp/thunderhub/.env 
export file=$hp/thunderhub/.env.local #adding '.local' prevents overriding file when updating.
sned_sats
##### export LNDIP
store_LND_container_IP

#check port with netstat -tulnp
while true ; do
netstat -tuln | grep -q :2999 || { export thub_port="2999" && break ; }
netstat -tuln | grep -q :2998 || { export thub_port="2998" && break ; } 
netstat -tuln | grep -q :2997 || { export thub_port="2997" && break ; } 
netstat -tuln | grep -q :2996 || { export thub_port="2996" && break ; } 
netstat -tuln | grep -q :2995 || { export thub_port="2995" && break ; } 
announce "Unable to find a free port between 2995 and 2999 inclusive. Aborting." && return 1
done
parmanode_conf_add "thub_port=$thub_port"

#make sure bitcoin installed
if ! grep -q "bitcoin-end" $ic >$dn 2>&1 ; then
announce "Please install Bitcoin first. Aborting."
return 1
fi

#make sure lightning installed 
if ! grep -q "lnd-end" $ic >$dn 2>&1 && ! grep -q "lnddocker-end" $ic >$dn 2>&1 ; \
then
announce "Please install LND first. Aborting."
return 1
fi

#make sure docker installed
if ! which docker >$dn 2>&1 ; then 
announce "Please install Docker first. Aborting." 
return 1 
fi

cd $hp
git clone --depth 1 https://github.com/apotdevin/thunderhub.git
cd thunderhub
rm ./.env
installed_conf_add "thunderhub-start"

make_thub_env || return 1
make_thunderhub_account || return 1
build_thub || return 1 
run_thub_docker || return 1
enable_tor_thunderhub
unset version file password password2

installed_conf_add "thunderhub-end"
success "Thunderhub has finished being installed"
}
