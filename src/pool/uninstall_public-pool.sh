function uninstall_public-pool {

set_terminal ; echo -e "

########################################################################################
$cyan
                                 Uninstall Public-Pool 
$orange
    Are you sure? (y) (n)

########################################################################################
"
choose "x" 
read choice
set_terminal

if [[ $choice == "y" || $choice == "Y" ]] ; then true
    else 
    return 1
    fi

}

stop_pool
docker rm public-pool public-pool-ui
delete_line $bc "zmqpubrawblock=tcp://*:5000"
cd
rm -rf public-pool public-pool-ui
installed_conf_remove "public-pool"