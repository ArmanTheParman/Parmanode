function run_bitcoind {

set_terminal

        if grep -q "internal" $HOME/.parmanode/parmanode.conf >/dev/null 2>&1 # config file determines if bitcoin is running on an internal or external drive
        then    
                sudo systemctl start bitcoind.service &
                return 0
        fi



        if grep -q "external" $HOME/.parmanode/parmanode.conf >/dev/null 2>&1 #config file determines if bitcoin is running on an internal or external drive
        then
        echo "
########################################################################################                

	Please connect the drive, otherwise bitcoind will have errors.

########################################################################################    
"
enter_continue
        set_terminal
        sudo systemctl start bitcoind.service &
        fi

return 0
}


                         





