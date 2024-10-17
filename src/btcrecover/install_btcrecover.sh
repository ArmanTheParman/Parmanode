function install_btcrecover {
clear
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

########################################################################################

cd $pn/src/btcrecover

if [[ ! -d $hp/btcrecover_data ]] ; then mkdir -p $hp/btcrecover_data ; fi

docker build  -t btcrecover .
enter_continue "Pausing to check if build was successful."

docker run -d --network none $cpu --name btcrecover -v $hp/btcrecover_data:/home/parman/parmanode/btcrecover_data btcrecover 
installed_conf_add "btcrecover-start" 
fix_openssl_ripemd160
parmabox_exec "btcrecover" # borrow's parmabox function to make terinal better.
debug "fix open ssl done"

cd $hp/btcrecover_data && curl -LO https://raw.githubusercontent.com/first20hours/google-10000-english/refs/heads/master/google-10000-english.txt && \
curl -LO https://raw.githubusercontent.com/dwyl/english-words/refs/heads/master/words.txt && \
curl -LO https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt

if docker ps | grep -q btcrecover ; then
    installed_conf_add "btcrecover-end" 
    success "BTC Recover tool is installed and running in a container." 
    return 0
else
    announce "Installation seems to have failed."
    return 1
fi

}