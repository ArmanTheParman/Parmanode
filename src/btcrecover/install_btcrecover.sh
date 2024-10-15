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

# if [[ $debug == 1 ]] ; then cache="--no-cache" ; else unset cache ; fi
docker build $cache -t btcrecover .
enter_continue "Pausing to check if build was successful."

#decide on how many cores to use
set_cores || return 1
if [[ $corechoice == default ]] ; then 
    unset cpu 
else
    cpu="--cpus=$corechoice"
fi

docker run -d --network none $cpu --name btcrecover -v $hp/btcrecover_data:/home/parman/parmanode/btcrecover_data btcrecover 
installed_conf_add "btcrecover-start" 
fix_openssl_ripemd160
debug "fix open ssl done"

if docker ps | grep -q btcrecover ; then
    installed_conf_add "btcrecover-end" 
    success "BTC Recover tool is installed and running in a container." 
    return 0
else
    announce "Installation seems to have failed."
    return 1
fi

}

function set_cores {

unset corechoice

    if [[ $OS == Mac ]] ; then
        export cores=$(sysctl -n hw.ncpu)
    elif [[ $OS == Linux ]] ; then
        export cores=$(nproc)
    fi

while true ; do
set_terminal ; echo -e "
########################################################################################

    Your computer has$pink $cores ${orange}number of available cores. 
    
    You can choose how many cores to dedicate to this container, or leave it as a 
    default. It you push the resources hard, for the purpose of brute forcing a 
    password, you can later stop the container to allow the cores to be used by your 
    system - Don't forget or your computer will remain sluggish.

    Please choose:

                Enter a$green number$orange, up to the max specified above
$orange
                or

                Hit$cyan <enter>$orange alone to use whatever the defaults are for Docker

########################################################################################
"
choose epqm ; read choice ; set_terminal

case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;

"") export corechoice=default
    break 
    ;;
*)
    if [[ $choice =~ [0-9\.]+ ]] ; then
    corechoice=$choice
    break
    fi
    
    invalid
    continue
    ;;
esac
done

}
