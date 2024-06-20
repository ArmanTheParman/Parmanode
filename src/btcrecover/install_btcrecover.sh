function install_btcrecover {

#make sure docker installed
if ! which docker >/dev/null 2>&1 ; then 
announce "Please install Docker first. Aborting." 
return 1 
fi

#check Docker running, esp Mac
if ! docker ps >/dev/null 2>&1 ; then echo -e "
########################################################################################

    Docker doesn't seem to be running. Please start it and, once it's running, hit $green 
    <enter>$orange to continue.

########################################################################################
"
choose "emq"
read choice ; case $choice in Q|q) exit 0 ;; m|M) back2main ;; esac
set_terminal
if ! docker ps >/dev/null 2>&1 ; then echo -e "
########################################################################################

    Docker is still$red not running$orange. 

    It can take a while to be in a 'ready state' even though you started it. Try
    again later. 
    
    Aborting. 

########################################################################################
"
enter_continue
return 1
fi
fi


# remove later...
if [[ $debug !=1 ]] ; then
docker stop btcrecover && docker rm btcrecover
fi

########################################################################################

cd $pn/src/btcrecover

docker build -t btcrecover .

# docker network create --internal no-internet

# docker run -d --network no-internet --name btcrecover btcrecover  

docker run -d --name btcrecover btcrecover


}