function install_public_pool {

if ! which docker >/dev/null 2>&1 ; then install_docker_linux ; fi
if ! which nginx >/dev/null 2>&1 ; then install_nginx ; fi
cd $hp

git clone --depth 1 https://github.com/benjamin-wilson/public-pool.git public_pool
git clone --depth 1 https://github.com/benjamin-wilson/public-pool-ui.git public_pool_ui
installed_conf_add "public_pool-start"

########################################################################################
# Start with public_pool
########################################################################################
cd $hp/public_pool
make_public_pool_env ; debug "made env"
# Add ZMQ connection to bitcoin.conf
# Parmanode uses port 3000 for RTL, so can't use that for pool.
echo "zmqpubrawblock=tcp://*:5000" | tee -a $bc >/dev/null ; debug "$bc edited"

#Fix dependencies
if uname -m | grep -q arm || [[ $computer_type == Pi ]] ; then
    fix_Dockerfile_pool_ARM ; debug "fix arm done" #ARM build failes unless extra dependencies installed
fi
debug "fix docker file after if, done? ctype= $computer_type ; 
$(uname -m)"

#start container
if [[ $OS == Linux ]] ; then
    docker build -t public_pool . ; debug "build done"
    docker run -d --name public_pool --network=host -v $hp/public_pool/.env:/.env public_pool ; debug "run pool done"

elif [[ $OS == Mac ]] ; then

    docker run -d --name public_pool -p 3333:3333 -p 3334:3334 -v $hp/public_pool/.env:/.env public_pool ; debug "run pool done"

fi


########################################################################################
# Next public_pool_ui
########################################################################################
cd $hp/public_pool_ui
docker build -t public_pool_ui . ; debug "build done"
docker run -d --name public_pool_ui -p 5050:80 public_pool_ui ; debug "run done"

make_ssl_certificates "public_pool_ui" ; debug "certs done"

if docker ps | grep "public_pool" | grep -q "public_pool_ui" ; then
success "Public Pool" "being installed"
installed_conf_add "public_pool-end"
else
announce "Something went wrong"
fi
}


function fix_Dockerfile_pool_ARM {
file="$hp/public_pool/Dockerfile"
cd $hp/public_pool
swap_string "$file" "python3" "python3 ca-certificates cmake curl " 
python_edit_add_backslash

debug "after swap_string"
}


function python_edit_add_backslash {
search_string="cmake curl"
input_file="$hp/public_pool/Dockerfile"

python3 - <<END
with open("$input_file", 'r') as file:
    lines = file.readlines()

with open("$input_file", 'w') as file:
    for line in lines:
        if "$search_string" in line:
            line = line.rstrip('\n') + '\\\n'
        file.write(line)
END
}