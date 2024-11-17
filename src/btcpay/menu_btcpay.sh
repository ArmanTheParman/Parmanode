function menu_btcpay {
while true ; do
btcpaylog="$HOME/.btcpayserver/btcpay.log"

set_btcpay_version_and_menu_print 

menu_bitcoin menu_btcpay #gets variables output1 for menu text, and $bitcoinrunning
isbtcpayrunning
if [[ $btcpayrunning != "true" ]] \
&& docker ps | grep -q btcpay ; then
containeronly="${cyan}Container RUNNING$orange"
else
unset containeronly
fi

if echo $output1 | grep -q "choose" ; then
output2=$(echo "$output1" | sed 's/start/sb/g') #choose start to run changed to choose sb to run. Option text comes from another menu.
else
output2="$output1"
fi
debug "before clear"
clear
unset menu_tor enable_tor_menu tor_on 

if sudo cat $macprefix/var/lib/tor/btcpay-service/hostname 2>$dn | grep -q "onion" \
   && sudo grep -q "7003" $torrc \
   && sudo grep -q "btcpay-service" $torrc ; then 

    get_onion_address_variable btcpay 
    menu_tor="    TOR: $bright_blue
        http://$ONION_ADDR_BTCPAY:7003$orange
        "
else
    if ! sudo grep -q "7003" $torrc ; then
    enable_tor_menu="$bright_blue             tor)$orange          Enable Tor"
    else
    unset enable_tor_menu 
    fi
fi
debug "before set terminal"
set_terminal_custom 52 
echo -en "
########################################################################################
                               ${cyan}BTCPay Server Menu${orange}
                                   $yellow$menu_btcpay_version$orange
########################################################################################

"
if [[ $btcpayrunning == "true" ]] ; then echo -e "
                   BTCPay SERVER IS$green RUNNING$orange" 
else
echo -e "
                   BTCPay SERVER IS$red NOT RUNNING$orange"
fi

echo -ne "
$output2" 

echo -e "

$cyan
             s)$orange            Start/Stop Docker container and BTCPay
$cyan
             rs)$orange           Restart BTCPay Docker container
$cyan
             c)$orange            Connect BTCPay to LND
$cyan
             conf)$orange         Config files ...
$cyan
             log)$orange          Logs ...
$cyan
             sb)$orange           Start/Stop Bitcoin
$cyan
             br)$orange           Backup / Restore BTCPay data ...
$cyan
             up)$orange           Update BTCPay ...
$cyan
             exp)$orange          Manage container (for experts)
$cyan
             pp)$orange           BTC ParmanPay - Online payment app, worldwide access

$enable_tor_menu

    FOR ACCESS:     

        http://${IP}:23001$yellow           
        from any computer on home network    $orange

        http://localhost:23001$yellow       
        from this computer $orange

$menu_tor
########################################################################################
" 
choose "xpmq" ; read choice ; set_terminal
case $choice in Q|q|QUIT|Quit|quit) exit 0 ;;
p|P) 
if [[ $1 == overview ]] ; then return 0 ; fi
menu_use ;; 
m|M) back2main ;;

conf)
set_terminal ; echo -e "
########################################################################################
    
    Next time, you can go directly to either the BTCPay log or the NBXplorer configs 
    by typing$green bc$orange or$green nc$orange. 

$cyan
             bc)$orange           BTCPay config file (${red}bcv$orange for vim)
$cyan
             nc)$orange           NBXplorer config file (${red}ncv$orange for vim)


########################################################################################
"
            choose xpmq ; read choice ; set_terminal
            case $choice in
            q|Q) exit ;; p|P) continue ;; m|M) back2main ;; "") continue ;;
            bc)
            menu_btcpay_conf_selection bc
            ;;
            bcv)
            menu_btcpay_conf_selection bcv
            ;;
            nc)
            menu_btcpay_conf_selection nc
            ;;
            ncv)
            menu_btcpay_conf_selection ncv
            ;;
            esac
;;
bc)
menu_btcpay_conf_selection bc
;;
bcv)
menu_btcpay_conf_selection bcv
;;
nc)
menu_btcpay_conf_selection nc
;;
ncv)
menu_btcpay_conf_selection ncv
;;
c|C|Connect|connect)
connect_btcpay_to_lnd
;;
s|S)
if [[ $btcpayrunning == "false" ]] ; then
start_btcpay
else
stop_btcpay
fi
;;
exp)
btcpay_manage_container
;;

rs)
restart_btcpay
;;

log)
set_terminal ; echo -e "
########################################################################################
    
    Next time, you can go directly to either the BTCPay log or the NBXplorer log 
    by typing$green blog$orange or$green nlog$orange. 

            $cyan
                        blog)$orange         View BTCPay Server log $cyan
            $cyan
                        nlog)$orange         View NBXplorer log $cyan
$orange
########################################################################################
"
            choose xpmq ; read choice ; set_terminal
            case $choice in
            q|Q) exit ;; p|P) continue ;; m|M) back2main ;; "") continue ;;
            blog|BLOG|bl|BL)
            menu_btcpay_log
            ;;
            nlog|NLOG|nl|NL|Nl)
            menu_nbxplorer_log
            ;;
            *)
            continue
            ;;
            esac
;;
blog|BLOG)
menu_btcpay_log
;;

nlog|NLOG|nl|NL|Nl)
menu_nbxplorer_log
;;

pp|PP|Pp|pP)
btcparmanpay
;;

tor)
if [[ -n $enable_tor_menu ]] ; then
enable_tor_btcpay
success "BTC Pay over Tor enabled"
continue
fi
;;

sb)
if [[ $btcpbitcoinrunning == "true" ]] ; then
stop_bitcoin
else
start_bitcoin
fi
;;

up)
update_btcpay
;;
debug)
true
;;

manr)
menu_btcpay_manr
;;
manp)
menu_btcpay_manp
;;
man)
menu_btcpay_man
;;
br)
yesorno "Do you want to backup BTCPay or restore?" "bk" "Backup" "res" "Restore" \
     && { backup_btcpay ; continue ; }
     restore_btcpay
;;
bk)
backup_btcpay
;;
res)
restore_btcpay
;;
*)
invalid ;;
esac  

done
return 0
}

function update_btcpay {
while true ; do
set_terminal ; echo -e "
########################################################################################

    BTCPay cannot be updated in the advertised way when run with Parmanode.
    
    But not to worry. Parmanode can do the update for you, without affecting your
    data.

    It will stop the services running, pull the desired version from GitHub, build
    the binaries again inside the docker container, and restart the service.

    You have options...
$cyan
                a)$orange          Abort!
$green
                pp)$orange         Get the latest version tested by Parman
$red
                yolo)$orange       Get the latest version, without Parman's testing.
$red                
                s)$orange          Select a particular version of your choice

########################################################################################
"
choose xpmq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; a|A|p|P) return 1 ;; m|M) back2main ;;

esac
done
}

function set_btcpay_version_and_menu_print {
#the version is unknown if the user chooses "latest version from github". The "latest" flag in parmanode.conf triggers the code to
#find the version and set it correctly version from the log file - BTCPay needs to have run at least once for this to work
source $pc

#if variable incorrect, fix it.
if [[ $btcpay_version == latest || -z $btcpay_version ]] ; then

    export btcpay_version=v$(cat $btcpaylog | grep "Adding and executing plugin BTCPayServer -" | tail -n1 | grep -oE '[0-9]+\.[0-9]+.[0-9]+.[0-9]+$')

    if [[ $(echo $btcpay_version | wc -c) -lt 3 ]] ; then #variable may not have captured correctly, if so, it'll be just 'v\n' with a length of 2.
        unset menu_btcpay_version
        source $pc #revert btcpay_version to original
    else
        #version captured correctly, and set in parmanode_conf
        export menu_btcpay_version=$btcpay_version
        parmanode_conf_add "btcpay_version=$btcpay_version" 
    fi

else
export menu_btcpay_version=$btcpay_version
fi
debug "pause for btcpay version menu print"
}

function backup_btcpay {
if [[ $btcpayrunning != "true" ]] ; then announce "BTCPay needs to be running." ; return ; fi

while true ; do
set_terminal ; echo -e "
########################################################################################

    Parmanode will backup your posgres database to a file. This has all your BTCPay
    server's details like the store's details and transaction data. There will also 
    be a backup of your Plugins directory.

    The backup will be saved to the directory $bright_blue

    $HOME/Desktop/btcpayserver_backup_date/        $orange

    Proceed?
$cyan
                 y)$orange     Yeah, of course, backups are super important
$cyan
                 n)$orange     Nah

########################################################################################
"
choose xpmq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; n|N|p|P) return 1 ;; m|M) back2main ;;
y)
backupdir=$HOME/Desktop/btcpayserver_backup_$(date | awk '{print $1$2$3$4"-"$5}')
#back up plugins dir
mkdir -p $backupdir >/dev/null 2>&1
cp -r $HOME/.btcpayserver/Plugins $backupdir/Plugins
docker exec -itu postgres btcpay bash -c "pg_dump -U postgres -d btcpayserver" > $backupdir/btcpayserver.sql 2>&1
success "A backup has been created and left on your Desktop"
break
;;
*)
invalid
;;
esac
done
}

function restore_btcpay {
if [[ $btcpayrunning != "true" ]] ; then announce "BTCPay needs to be running." ; return ; fi
while true ; do
set_terminal ; echo -e "
########################################################################################

    Parmanode will restore your backup files to the current BTCPay installation.

    This will destroy the current data in BTCPay server.   

    Do it?
$cyan
                             y)$orange          Yeah, restore
$cyan
                             n)$orange          Nah


########################################################################################
"
choose xpmq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; n|N|p|P) return 1 ;; m|M) back2main ;;
y)
set_terminal ; echo -e "
########################################################################################

    Please type the full path of the backup file, eg:
$cyan
    $HOME/Desktop/btcpayserver.sql
$orange
########################################################################################
"
read file ; set_terminal
if [[ ! -f $file ]] ; then announce "The file doesn't exist - $file" ; continue ; fi
if ! grep -iq "PostgreSQL database dump" $file >/dev/null 2>&1 ; then
yesorno "Doesn't seem to be a valid PostgresSQL file. Ignore and proceed?" || continue ; fi
docker cp $file btcpay:/home/parman/backup.sql
#docker exec -itu postgres btcpay bash -c "pg_restore -U parman -d btcpayserver --clean /home/parman/backup.sql" &&
docker exec -itu postgres btcpay bash -c "psql -U postgres -d btcpayserver -f /home/parman/backup.sql" &&
success "Backup restored" && return 0
enter_continue "something went wrong" ; return 1
break
;;
esac
done

}

function menu_btcpay_log {
set_terminal ; log_counter
if [[ $log_count -le 10 ]] ; then
echo -e "
########################################################################################
    
    This will show the BTCpay log file in real-time as it populates.
    
    You can hit$cyan <control>-c$orange to make it stop.

########################################################################################
"
enter_continue
fi
set_terminal_wider
tail -f $btcpaylog &
tail_PID=$!
trap 'kill $tail_PID' SIGINT #condition added to memory
wait $tail_PID # code waits here for user to control-c
trap - SIGINT # reset the trap so control-c works elsewhere.
set_terminal
}


function menu_nbxplorer_log {
echo "
########################################################################################
    
    This will show the NBXplorer log file in real time as it populates.
    
    You can hit$cyan <control>-c$orange to make it stop.

########################################################################################
"
enter_continue
set_terminal_wider
tail -f $HOME/.nbxplorer/nbxplorer.log &
tail_PID=$!
trap 'kill $tail_PID' SIGINT #condition added to memory
wait $tail_PID # code waits here for user to control-c
trap - SIGINT # reset the trap so control-c works elsewhere.
set_terminal
}

function menu_btcpay_conf_selection {

if [[ $1 == bc ]] ; then
nano $HOME/.btcpayserver/Main/settings.config
elif [[ $1 == bcv ]] ; then
vim_warning ; vim $HOME/.btcpayserver/Main/settings.config
elif [[ $1 == nc ]] ; then
nano $HOME/.nbxplorer/Main/settings.config
elif [[ $1 == ncv ]] ; then
vim_warning ; vim $HOME/.nbxplorer/Main/settings.config
fi

}

function btcpay_manage_container {
while true ; do
set_terminal ; echo -e "
########################################################################################

     Extra features for advanced users...

$cyan
             dco)$orange          Start Docker container only $containeronly
$cyan
             man)$orange          Manually access container $red(parman user)$orange
$cyan
             manr)$orange         Manually access container $red(root user)$orange
$cyan
             manp)$orange         Manually access container $red(posgres user)$orange


########################################################################################
"
choose xpmq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; p|P) continue ;; m|M) back2main ;; 
dco)
if [[ $btcpayrunning == "true" ]] ; then
    yesorno "BTCPay needs to be stopped to run the container only. Do that?" \
    && stop_btcpay && docker start btcpay \
    && enter_continue "The container has been started. NOTE: BTCPay & NBXplorer are$red not running$orange." \
    && return 0 
    return 0 #choosing no
else
docker start btcpay
enter_continue "The container has been started. NOTE: BTCPay & NBXplorer are$red not running$orange."
return 0
fi
;;
man)
menu_btcpay_man
;;
manp)
menu_btcpay_manp
;;
manr)
menu_btcpay_manr
;;
*)
invalid
;;
esac
done
}

function menu_btcpay_manr {
if ! docker exec -itu root btcpay bash -c "grep -q 'parmashell_functions' /etc/bash.bashrc" ; then
docker exec -du root btcpay bash -c "echo 'source /home/parman/parman_programs/parmanode/src/ParmaShell/parmashell_functions' | tee -a /etc/bash.bashrc >/dev/null" 
fi
if ! docker exec -itu root btcpay bash -c "grep -q '#colour_function' /etc/bash.bashrc" ; then
docker exec -du root btcpay bash -c "echo 'colour 2>/dev/null #colour_function' | tee -a /etc/bash.bashrc >/dev/null"
fi
enter_continue "Type exit and <enter> to return from container back to Parmanode."
clear
docker exec -itu root btcpay bash 

}

function menu_btcpay_manp {
if ! docker exec -it btcpay bash -c "grep -q 'parmashell_functions' /etc/bash.bashrc" ; then
docker exec -du root btcpay bash -c "echo 'source /home/parman/parman_programs/parmanode/src/ParmaShell/parmashell_functions' | tee -a /etc/bash.bashrc >/dev/null"
fi
if ! docker exec -itu root btcpay bash -c "grep -q '#colour_function' /etc/bash.bashrc" ; then
docker exec -du root btcpay bash -c "echo 'colour 2>/dev/null #colour_function' | tee -a /etc/bash.bashrc >/dev/null"
fi
clear
#echo -e "${green}The sudo password for parman is 'parmanode'$orange"
enter_continue "Type exit and <enter> to return from container back to Parmanode."
clear
docker exec -itu postgres btcpay bash 
}

function menu_btcpay_man {
if ! docker exec -it btcpay -c "grep -q 'parmashell_functions' /etc/bash.bashrc" ; then
docker exec -du root btcpay bash -c "echo 'source /home/parman/parman_programs/parmanode/src/ParmaShell/parmashell_functions' | tee -a /etc/bash.bashrc >/dev/null" 
fi
if ! docker exec -itu root btcpay bash -c "grep -q '#colour_function' /etc/bash.bashrc" ; then
docker exec -du root btcpay bash -c "echo 'colour 2>/dev/null #colour_function' | tee -a /etc/bash.bashrc >/dev/null"
fi
clear
echo -e "${green}The sudo password for parman is 'parmanode'$orange"
enter_continue "Type exit and <enter> to return from container back to Parmanode."
clear
docker exec -it btcpay bash 
}