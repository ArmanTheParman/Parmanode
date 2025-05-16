function menu_btcpay {
if ! grep -q "btcpay.*end" $ic ; then menu_main ; fi
while true ; do
please_wait
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
    enable_tor_menu="$bright_blue             tor)$orange          Enable Tor
    "
    else
    unset enable_tor_menu 
    fi
fi

debug "before set terminal"
set_terminal 52 88
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
             start)$orange        Start Docker container and BTCPay
$cyan
             stop)$orange         Start Docker container and BTCPay
$cyan
             rs)$orange           Restart BTCPay Docker container
$cyan
             c)$orange            Connect BTCPay to LND
$cyan
             conf)$orange         Config files ...
$cyan
             log)$orange          Logs ...
$cyan
             br)$orange           Backup / Restore BTCPay data ...$red (new!)
$cyan
             up)$orange           Update BTCPay ... $red (new!)
$cyan
             exp)$orange          Manage container $red (for experts) $orange
$cyan
             pp)$orange           BTC ParmanPay - Online payment app, worldwide access

$enable_tor_menu
    FOR ACCESS:     

        http://${IP}:23001$red
        from any computer on home network    $orange

        http://localhost:23001$red
        from this computer $orange

$menu_tor
########################################################################################
" 
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in 
Q|q|QUIT|Quit|quit) exit 0 ;; m|M) back2main ;;
p|P) 
if [[ $1 == overview ]] ; then return 0 ; fi
menu_use 
;; 
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
            choose xpmq ; read choice 
            jump $choice || { invalid ; continue ; } ; set_terminal
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
start)
start_btcpay
;;
stop)
stop_btcpay
;;
exp)
btcpay_menu_advanced || return 1
;;

restart|rs)
restart_btcpay
;;

log)
set_terminal ; echo -e "
########################################################################################
    
    Next time, you can go directly to either the BTCPay log or the NBXplorer log 
    by typing$green blog$orange or$green nlog$orange. 

            $cyan
                        blog)$orange         View BTCPay Server log (or l or b) $cyan
            $cyan
                        nlog)$orange         View NBXplorer log (or n) $cyan
$orange
########################################################################################
"
            choose xpmq ; read choice 
            jump $choice || { invalid ; continue ; } ; set_terminal
            case $choice in
            q|Q) exit ;; p|P) continue ;; m|M) back2main ;; "") continue ;;
            b|l|blog|BLOG|bl|BL)
            menu_btcpay_log
            ;;
            n|nlog|NLOG|nl|NL|Nl)
            menu_nbxplorer_log
            ;;
            *)
            continue
            ;;
            esac
;;
l|b|blog|BLOG)
menu_btcpay_log
;;

n|nlog|NLOG|nl|NL|Nl)
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
#announce "Not available just yet"
#continue
yesorno "Do you want to backup BTCPay or restore?" "bk" "Backup" "res" "Restore" \
      && { backup_btcpay ; continue ; }
      announce "Restoration is only possible if you uninstall BTCPay Server first, 
                \r    then choose to restore during the install process."
;;
"")
continue ;;
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

    Because BTCPay in Parmanode is a bespoke installation, the standard update
    methods for BTCPay don't work.
    
    But not to worry! Parmanode can do the update for you, without affecting your
    data. It is recommended, nevertheless, that you do backup your data using the
    backup feature from the Parmanode BTCPay menu.

    The update works by first stopping the services running, then pulling the 
    desired version from GitHub, building the binaries again inside the docker 
    container, and then restarting the service.

    You have options...
$cyan
                a)$orange          Abort!
$green
                pp)$orange         Get the latest version tested by Parman
$red                
                s)$orange          Select a particular version of your choice

########################################################################################
"
choose xpmq ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; a|A|p|P) return 1 ;; m|M) back2main ;;
pp)
version="v2.1.1"
nbxplorerversion="v2.5.26"
stop_btcpay 
docker start btcpay #container only
set_terminal
echo -e "${green}Updating to version $version. This can take a few minutes. \nSit back and stacks some sats...$orange"
docker exec -itu parman btcpay bash -c "cd /home/parman/parmanode/NBXplorer && git checkout $nbxplorerversion && ./build.sh"
docker exec -itu parman btcpay bash -c "cd /home/parman/parmanode/btcpayserver && git checkout $version && ./build.sh"
restart_btcpay
success "BTCPay Server has been updated to version $version"
parmanode_conf_remove "btcpay_version"
unset version btcpay_version
return 0
;;
s)
announce "Please enter the version you want in the format v0.0.0 for example:
\n$cyan    v2.1.1$orange"
version=$enter_cont
nbxplorerversion="v2.5.26"
if [[ ! $version =~ ^v ]] ; then version=v${version} ; fi #if user types a number, add a v prefix
if [[ ! $version =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]] ; then announce "Incorrect format." ; continue ; fi
stop_btcpay 
set_terminal 
echo -e "${green}Updating to version $version. This can take a few minutes. \nSit back and stacks some sats...$orange"
docker start btcpay #container only
docker exec -itu parman btcpay bash -c "cd /home/parman/parmanode/NBXplorer && git checkout $nbxplorerversion && ./build.sh"
docker exec -itu parman btcpay bash -c "cd /home/parman/parmanode/btcpayserver && git checkout $version && ./build.sh"
restart_btcpay
success "BTCPay Server has been updated to version $cyan$version$orange"
parmanode_conf_remove "btcpay_version"
unset version btcpay_version
return 0
;;
esac
done
}

function set_btcpay_version_and_menu_print {
#the version is unknown if the user chooses "latest version from github". The "latest" flag in parmanode.conf triggers the code to
#find the version and set it correctly version from the log file - BTCPay needs to have run at least once for this to work
unset btcpay_version
source $pc

debug "at start . btcpay version var = $btcpay_version"
#if variable incorrect, fix it.
if [[ $btcpay_version == latest || -z $btcpay_version ]] ; then
debug "btcpay version var = $btcpay_version"
    export btcpay_version=v$(cat $btcpaylog | grep "Adding and executing plugin BTCPayServer -" | tail -n1 | grep -oE '[0-9]+.[0-9]+.[0-9]+')
debug "btcpay version var = $btcpay_version"

    if [[ $(echo $btcpay_version | wc -c) -lt 3 ]] ; then #variable may not have captured correctly, if so, it'll be just 'v\n' with a length of 2.
        unset btcpay_version
        source $pc #revert btcpay_version to original
        debug " in if... btcpay version var = $btcpay_version"
    else
        #version captured correctly, and set in parmanode_conf
        export menu_btcpay_version=$btcpay_version
        parmanode_conf_add "btcpay_version=$btcpay_version" 
        debug "in else... btcpay version var = $btcpay_version"
    fi
debug "btcpay version var = $btcpay_version"

else
export menu_btcpay_version=$btcpay_version
fi
debug "pause for btcpay version menu print"
}

function backup_btcpay {
if [[ $btcpayrunning != "true" ]] ; then announce "BTCPay needs to be running." ; return ; fi

while true ; do
set_terminal ; echo -e "
########################################################################################$cyan
                            BTCPAY PARMANODE BACKUP$orange
########################################################################################

    Parmanode will backup your posgres database to a file. This has your BTCPay
    server's details like the store's details and transaction data. There will also 
    be a backup of your Plugins directory.

    The backup will be saved as a tar archive file to the desktop as:
$cyan
    btcpay_parmanode_backup.tar
$orange
    Proceed?
$cyan
                 y)$orange     Yeah, of course, backups are super important
$cyan
                 n)$orange     Nah, que sera sera

########################################################################################
"
choose xpmq ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
N|n) return 1 ;;
y)
backupdir="$HOME/Desktop/" ; mkdir -p $backupdir >$dn 2>&1
target="$backupdir/btcpay_parmanode_backup.tar"
tempdir="$(mktemp -d)"

# check for pre-existance
if [[ -f $target ]] ; then
    yesorno "The file$cyan $target$orange already exists.
                   $red    
             \r    OVERWRITE??$orange" || return 1
fi

#backup directories
cp -r $HOME/.btcpayserver/Plugins   $tempdir/Plugins
cp -r $HOME/.btcpayserver/Main      $tempdir/Main

#backup databases
if ! docker exec -itu postgres btcpay bash -c "pg_dumpall -U postgres" > $tempdir/btcpayserver.sql 2>&1 ; then 
    rm -rf $tempdir 
    enter_continue "Something went wrong with the database backup. Aborting." 
    return 1
fi

#tar it all up
if tar -czf $target $tempdir/* >$dn 2>&1 ; then
    rm -rf $tempdir 2>$dn 
    success "A backup has been created at $target. \n\n    
    \r    Please keep it safe. Use Parmanode to restore whenever needed. Note, 
    \r    lightning channels are not backed up - go to the LND menu for saving the 
    \r    static channel backup file."
    return 0    
else
    rm -rf $tempdir 2>&dn
    enter_continue "Something went wrong" ; jump $enter_cont
    return 1
fi
;;
"")
continue ;;
*)
invalid
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
enter_continue ; jump $enter_cont
fi
set_terminal 38 200
if ! which tmux >$dn 2>&1 ; then
yesorno "Log viewing needs Tmux installed. Go ahead and do that?" || continue
fi
TMUX2=$TMUX ; unset TMUX ; clear
tmux new -s btcpaylog "tail -f $btcpaylog"
TMUX=$TMUX2
}


function menu_nbxplorer_log {
echo -e "
########################################################################################
    
    This will show the NBXplorer log file in real time as it populates.
    
    You can hit$cyan <control>-c$orange to make it stop.

########################################################################################
"
enter_continue ; jump $enter_cont
set_terminal 38 200
    if ! which tmux >$dn 2>&1 ; then
    yesorno "Log viewing needs Tmux installed. Go ahead and do that?" || continue
    fi
    TMUX2=$TMUX ; unset TMUX ; clear
    tmux new -s nbxplorer_log "tail -f $HOME/.nbxplorer/nbxplorer.log"
    TMUX=$TMUX2
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



function menu_btcpay_manr {
if ! docker exec -itu root btcpay bash -c "grep -q 'parmashell_functions' /etc/bash.bashrc" ; then
docker exec -du root btcpay bash -c "echo 'source /home/parman/parman_programs/parmanode/src/ParmaShell/parmashell_functions' | tee -a /etc/bash.bashrc >$dn" 
fi
if ! docker exec -itu root btcpay bash -c "grep -q '#colour_function' /etc/bash.bashrc" ; then
docker exec -du root btcpay bash -c "echo 'colour 2>$dn #colour_function' | tee -a /etc/bash.bashrc >$dn"
fi
enter_continue "Type exit and <enter> to return from container back to Parmanode."
clear
docker exec -itu root btcpay bash 

}

function menu_btcpay_manp {
if ! docker exec -it btcpay bash -c "grep -q 'parmashell_functions' /etc/bash.bashrc" ; then
docker exec -du root btcpay bash -c "echo 'source /home/parman/parman_programs/parmanode/src/ParmaShell/parmashell_functions' | tee -a /etc/bash.bashrc >$dn"
fi
if ! docker exec -itu root btcpay bash -c "grep -q '#colour_function' /etc/bash.bashrc" ; then
docker exec -du root btcpay bash -c "echo 'colour 2>$dn #colour_function' | tee -a /etc/bash.bashrc >$dn"
fi
clear
#echo -e "${green}The sudo password for parman is 'parmanode'$orange"
enter_continue "Type exit and <enter> to return from container back to Parmanode."
clear
docker exec -itu postgres btcpay bash 
}

function menu_btcpay_man {
if ! docker exec -it btcpay -c "grep -q 'parmashell_functions' /etc/bash.bashrc" ; then
docker exec -du root btcpay bash -c "echo 'source /home/parman/parman_programs/parmanode/src/ParmaShell/parmashell_functions' | tee -a /etc/bash.bashrc >$dn" 
fi
if ! docker exec -itu root btcpay bash -c "grep -q '#colour_function' /etc/bash.bashrc" ; then
docker exec -du root btcpay bash -c "echo 'colour 2>$dn #colour_function' | tee -a /etc/bash.bashrc >$dn"
fi
clear
echo -e "${green}The sudo password for parman is 'parmanode'$orange"
enter_continue "Type exit and <enter> to return from container back to Parmanode."
clear
docker exec -it btcpay bash 
}

function btcpay_menu_advanced {
while true ; do

btcpaycontainerspps #checks running status of btcpay, nbxplorer, and postgres

set_terminal ; echo -e "
########################################################################################
$cyan
     Extra features for advanced users...
$orange
$cyan
             dco)$orange          Start Docker container only $containeronly
$cyan
             man)$orange          Manually access container $bright_blue(parman user)$orange
$cyan
             manr)$orange         Manually access container $bright_blue(root user)$orange
$cyan
             manp)$orange         Manually access container $bright_blue(posgres user)$orange
$cyan 
             btcp)$orange         Start BTCPay in container only $containerbtcpayrunning
$cyan 
             nbx)$orange          Start NBXplorer in container only $nbxplorerrunning
$cyan 
             post)$orange         Start Postgres in container only $posgresrunning
$cyan 
             del)$orange          Delete default btcpayserver database

########################################################################################
"
choose xpmq ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal

case $choice in
q|Q) exit ;; p|P) return 0 ;; m|M) back2main ;; 
dco)
stop_btcpay 
docker start btcpay #do not user start_btcpay()
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
btcp)
start_btcpay_indocker 
enter_continue
;;
nbx)
start_nbxplorer_indocker
enter_continue
;;
post)
start_postgres_btcpay_indocker 
enter_continue
;;
del)
# announce "not available just yet"
# continue

if [[ $btcpayrunning == "false" ]] ; then
announce "BTCPay Server needs to be running. If you're stuck, consider uninstall and reinstall."
continue
fi

yesorno "${red}ARE YOU SURE? THIS IS YOUR BTCPAY STORE DATA!$orange
\n    The btcpayserver and nbxplorer database will be deleted and created new.
\n    If you find this doesn't give you a clean enough slate, you can reinstall BTCPay 
    Server." || continue
please_wait

#terminate any connections
docker exec -itu parman btcpay /bin/bash -c "psql -U parman -d postgres -c \"
SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = 'btcpayserver';
SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = 'nbxplorer';\""
#delete databases
docker exec -itu parman btcpay /bin/bash -c "psql -U parman -d postgres -c 'DROP DATABASE btcpayserver;'" 
docker exec -itu parman btcpay /bin/bash -c "psql -U parman -d postgres -c 'DROP DATABASE nbxplorer;'" 
#create databases
docker exec -itu postgres btcpay /bin/bash -c "createdb -O parman btcpayserver && createdb -O parman nbxplorer" 
enter_continue
;;


*)
invalid
;;
esac
done
}

function btcpaycontainerspps {

    if docker exec -du postgres btcpay bash -c "ps ax | grep /usr/lib/postgresq | grep -qv grep" ; then
    export posgresrunning="${green}RUNNING$orange"
    else
    export posgresrunning="${red}NOT RUNNING$orange"
    fi

    if docker exec -it btcpay bash -c "ps ax | grep NBX | grep -v grep | grep -q csproj" ; then
    export nbxplorerrunning="${green}RUNNING$orange"
    else
    export nbxplorerrunning="${red}NOT RUNNING$orange"
    fi

    if docker exec -it btcpay bash -c "ps ax | grep btcpay | grep -v grep | grep -q csproj" ; then
    export containerbtcpayrunning="${green}RUNNING$orange"
    else
    export containerbtcpayrunning="${red}NOT RUNNING$orange"
    fi
}