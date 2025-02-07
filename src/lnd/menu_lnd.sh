function menu_lnd {
if ! grep -q "lnd.*end" $ic && ! grep -q "litd-end" $ic ; then return 0 ; fi
if grep -q "btccombo-end" $ic && ! grep -q "BTCIP" $pc && grep -q "127.0.0.1" $HOME/.lnd/lnd.conf ; then
while true ; do
set_terminal ; echo -e "
########################################################################################

    Parmanode has detected that LND is not configured to connect to Bitcoin Core 
    (Docker) correctly. 
    

    You have options...

$cyan
        fix) $orange    Parmanode will adjust the lnd.conf file automatically and restart LND 
$cyan
        i)     $orange  Ignore and continue
$cyan
        rrr)  $orange   RRR, don't ask me again.

########################################################################################
"
choose xpmq ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
rrr) 
echo "btccombo-check" >> $hm
break
;;
i)
break
;;
fix)
fix_BTC_addr_btccombo
please_wait
restart_lnd
break
;;
*)
invalid
;;
esac
done
fi

if grep -q "litd" $ic >$dn 2>&1 ; then 
lndlitd="true" 
LND=LITD
lndconf=lit.conf
else 
lndlitd="false" 
LND=LND
lndconf=lnd.conf
fi

while true ; do
set_terminal

please_wait
unset lnd_version lnddockermenu dkrmenu lndtor torhybrid inside_docker

if docker ps >$dn 2>&1 | grep -q lnd ; then
export lnddockermenu="true"
else
export lnddockermenu="false"
fi

if [[ $lnddockermenu == "false" ]] ; then #non docker
export lnd_version=$(lncli --version | cut -d - -f 1 | cut -d ' ' -f 3) 
unset dkrmenu inside_docker
elif [[ $lnddockermenu == "true" ]] ; then
export lnd_version=$(docker exec lnd lncli --version | cut -d - -f 1 | cut -d ' ' -f 3)
dkrmenu="
      (dks)            Start Docker container (and LND)

      (dkst)           Stop Docker container (and LND)
"
inside_docker="(within running Docker container)"
fi

# To check if wallet is created/loaded
if lncli walletbalance >$dn 2>&1 || docker exec lnd lncli walletbalance >$dn 2>&1 ; then 
wallet="WALLET CREATED & UNLOCKED =$green TRUE$orange" 
else
wallet="WALLET CREATED & UNLOCKED =$red FALSE $yellow... usually just wait a
                                                              minute, and it'll unlock$orange" 
fi 

# To print tor details in menu
unset lndtor torhybrid
if grep -q "tor.skip-proxy-for-clearnet-targets" $HOME/.lnd/lnd.conf ; then #works because of lnd to litd symlink
    lndtor=Enabled
else
    lndtor=Disabled
fi

if grep -q "tor.skip-proxy-for-clearnet-targets=true" $HOME/.lnd/lnd.conf 
then 
    torhybrid=Enabled
else 
    torhybrid=Disabled 
fi

#get onion address if it exists...
unset lnd_onion clearnetURI

if [[ $lnddockermenu == "false" ]] ; then 
lncli getinfo >$dp/lndinfo.log 2>$dn
else
docker exec lnd lncli getinfo >$dp/lndinfo.log 2>$dn
fi

if grep -q onion: $dp/lndinfo.log ; then
lnd_onion="
$bright_blue
Tor Onion URI:

$(cat $dp/lndinfo.log | grep onion: | cut -d \" -f 2) $orange"
fi

if [[ $lndtor == "Enabled" && -z $lnd_onion ]] ; then
lnd_onion="
$bright_blue
LND onion address can take a few minutes to appear when first enabled.
Of course, LND must be running also to make an onion address appear.
Or much longer if Bitcoin hasn't finished sync'ing yet.$orange"

fi

if cat $dp/lndinfo.log | grep :973 | grep -v onion >$dn 2>&1 ; then 
clearnetURI="
$yellow
Clearnet URI:

$(cat $dp/lndinfo.log | grep :973 | grep -v onion | cut -d \" -f 2)
$orange
Parmanode will not set up nor detect port forwarding (allows others to connect to you)
To set it up, forward port $lnd_port to IP: $IP
$orange"
fi

if [[ $lndtor == Enabled ]] ; then
colour1="$green" ; else colour1="$red" ; fi

if [[ $torhybrid == Enabled ]] ; then
colour2="$green" ; else colour2="$red" ; fi

if [[ $lnddockermenu == "false" ]] ; then

    if ps -x | grep litd | grep bin >$dn 2>&1 ||\
    ps -x | grep lnd | grep bin >$dn 2>&1 ; then
    lndrunning="true"
    else 
    lndrunning="false"
    fi

else #docker

    if docker exec lnd pgrep lnd >$dn 2>&1 ; then
    lndrunning="true"
    else 
    lndrunning="false"
    fi
fi

set_terminal_custom 55 ; echo -e "
########################################################################################$cyan
                                LND Menu${orange} - v$lnd_version                               
########################################################################################

"
if [[ $lndrunning == "true" ]] ;  then echo -ne "
                   LND IS$green RUNNING$orange -- SEE LOG MENU FOR PROGRESS "
else
echo -en "
                   LND IS$red NOT RUNNING$orange -- CHOOSE \"start\" TO RUN"
fi
echo -ne "
                        $wallet 
$menuDockerIP

$cyan
      i)$orange              Important info
$cyan
      s)$orange              Start $LND $orange$inside_docker 
$cyan
      stop)$orange           Stop $LND $orange$inside_docker 
$cyan
      rs)$orange             Restart $LND $inside_docker
$cyan
      wt)$orange             Enable/Disable Watch Tower Service$pink NEW
$cyan
      wtc)$orange            Connect to a remote Watch Tower$pink NEW
$dkrmenu
      log)$orange            Inspect LND logs
$cyan
      conf)$orange           Inspect and edit $lndconf file (confv for vim)
$cyan
      scb)$orange            Static Channel Backup 
$bright_blue
      t)$orange              Enable/disable TOR $pink $orange      Currently: $colour1$lndtor$orange
$cyan
      th)$orange             Enable/disable Clearnet with Tor      Currently: $colour2$torhybrid$orange
$cyan
      w)$orange              ... wallet options
$cyan
      mm)$orange             ... more options
$lnd_onion $clearnetURI
$red $blinkon                                                      r to refresh $blinkoff$orange       
########################################################################################
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in 
m|M) back2main ;; q|Q|QUIT|Quit) exit 0 ;;
p|P) 
if [[ $1 == overview ]] ; then return 0 ; fi
menu_use ;; 
i|I|info|Info) lnd_info ; continue ;;
s|S|start|START|Start) start_lnd  ; continue ;;
stop|STOP|Stop) stop_lnd ; continue ;; 
rs|RS|Rs|restart|RESTART|Restart) restart_lnd ; continue ;;
r|R) menu_lnd ;;

t|T|tor)
if [[ $lndtor == Disabled ]] ; then
lnd_tor only
debug "if true"
else
lnd_tor off
debug "else"
fi
;;

wt)
watchtower_toggle 
;;

th)
if [[ $torhybrid == Disabled ]] ; then
lnd_tor both
else
lnd_tor only
fi

;;
prv|PRV|Prv)
if grep -qE '^lnd.externalip' $HOME/.lit/lit.conf \
|| grep -qE '^externalip' $HOME/.lnd/lnd.conf ; then
fully_tor_only
else
reverse_fully_tor_only
fi
;;


log|LOG|Log)
log_counter

if [[ $log_count -le 10 ]] ; then
echo -e "
########################################################################################
    
    This will show the systemd output for LND in real-time as it populates.
    
    You can hit$cyan <control>-c$orange to make it stop.

########################################################################################
"
enter_continue
fi

set_terminal_wider

if ! which tmux >$dn 2>&1 ; then
yesorno "Log viewing needs Tmux installed. Go ahead and do that?" || continue
fi
TMUX2=$TMUX ; unset TMUX ; clear
if grep -q "lnd-" $ic ; then
tmux new -s lnd_log "journalctl -fexu lnd.service"
elif grep -q "litd" $ic ; then
tmux new -s litd_log "journalctl -fexu litd.service"
elif grep -q "lnddocker-" $ic ; then
tmux new -s lnddocker_log "tail -f $hp/lnd/lnd.log"
fi
TMUX=$TMUX2

please_wait

;;


conf)
if grep -q "litd" $ic >$dn 2>&1 ; then
menu_lnd_lit_conf="litd.conf"
rL=LITD
open_conf="$HOME/.lit/lit.conf"
else
menu_lnd_lit_conf="lnd.conf"
rL=LND
open_conf="$HOME/.lnd/lnd.conf"
fi

echo -e "
########################################################################################
    
        This will run Nano text editor to edit $menu_lnd_lit_conf. See the controls
        at the bottom to save and exit. Be careful messing around with this file.

$green
	  *** ANY CHANGES WILL ONLY BE APPLIED ONCE YOU RESTART $rL ***
$orange
########################################################################################
"
enter_continue ; jump $enter_cont
nano $open_conf
please_wait
unset menu_lnd_lit_conf rL open_conf
continue 
;;

confv)

if grep -q "litd" $ic >$dn 2>&1 ; then
menu_lnd_lit_conf="litd.conf"
rL=LITD
open_conf="$HOME/.lit/lit.conf"
else
menu_lnd_lit_conf="lnd.conf"
rL=LND
open_conf="$HOME/.lnd/lnd.conf"
fi
vim_warning ; vim $open_conf
please_wait
unset menu_lnd_lit_conf rL open_conf
continue 
;;

scb|SCB|Scb) 
scb ;;

w)
menu_lnd_wallet 
;;

mm)
menu_lnd_more ;;

*) invalid ;;

esac ; done

#option to turn tor on/off

#lncli getinfo

}


function fully_tor_only {
# check tor enabled - or do it.
# check hybrid off - or do it.
# comment out tlsextrip
# comment out tlsextradomain
# comment out externalip 
nogsedtest
export file=$HOME/.lnd/lnd.conf

lnd_tor only skipsuccess norestartlnd

if grep -q "litd" $ic >$dn 2>&1 ; then

    sudo gsed -i '/^lnd.tlsextraip/s/^/; /' $file
    sudo gsed -i '/^lnd.tlsextradomain/s/^/; /' $file
    sudo gsed -i '/^lnd.externalip/s/^/; /' $file

else

    sudo gsed -i '/^tlsextraip/s/^/; /' $file
    sudo gsed -i '/^tlsextradomain/s/^/; /' $file
    sudo gsed -i '/^externalip/s/^/; /' $file

fi

restart_lnd

success "LND" "being made to run by Tor-only"
}

function reverse_fully_tor_only {


export file=$HOME/.lnd/lnd.conf

if grep -q "litd" $ic >$dn 2>&1 ; then

    if grep -q lnd.tlsextraip $file ; then
    if [[ $(cat $file | grep tlsextraip | wc -l) == 1 ]] ; then #if string found only once
    gsed -i '/^; lnd.tlsextraip/s/^..//' $file
    else
    announce "Unexpectedly found 'lnd.tlsextraip' more than once in lit.conf.
        Abandoning automated modification to avoid errors."
    return 1
    fi
    fi

    if grep -q lnd.externalip $file ; then
    if [[ $(cat $file | grep lnd.externalip | wc -l) == 1 ]] ; then #if string found only once
    gsed -i '/^; lnd.externalip/s/^..//' $file
    else
    announce "Unexpectedly found 'lnd.externalip' more than once in lit.conf.
        Abandoning automated modification to avoid errors."
    return 1
    fi
    fi
    
    sudo gsed -i "/lnd.tlsextradomain=mydomain.com/d" $file

    if grep -q lnd.tlsextradomain $file ; then
    if [[ $(cat $file | grep lnd.tlsextradomain | wc -l) == 1 ]] ; then #if string found only once
    gsed -i '/^; lnd.tlsextradomain/s/^..//' $file
    else
    announce "Unexpectedly found 'lnd.tlsextradomain' more than once in lit.conf.
        Abandoning automated modification to avoid errors."
    return 1
    fi
    fi


else

    if grep -q tlsextraip $file ; then
    if [[ $(cat $file | grep tlsextraip | wc -l) == 1 ]] ; then #if string found only once
    gsed -i '/^; tlsextraip/s/^..//' $file
    else
    announce "Unexpectedly found 'tlsextraip' more than once in lnd.conf.
        Abandoning automated modification to avoid errors."
    return 1
    fi
    fi

    if grep -q externalip $file ; then
    if [[ $(cat $file | grep externalip | wc -l) == 1 ]] ; then #if string found only once
    gsed -i '/^; externalip/s/^..//' $file
    else
    announce "Unexpectedly found 'externalip' more than once in lnd.conf.
        Abandoning automated modification to avoid errors."
    return 1
    fi
    fi

    sudo gsed -i "/tlsextradomain=mydomain.com/d" $file

    if grep -q tlsextradomain $file ; then
    if [[ $(cat $file | grep tlsextradomain | wc -l) == 1 ]] ; then #if string found only once
    gsed -i '/^; tlsextradomain/s/^..//' $file
    else
    announce "Unexpectedly found 'tlsextradomain' more than once in lnd.conf.
        Abandoning automated modification to avoid errors."
    return 1
    fi
    fi

fi #end litd


if [[ $norestartlnd != "true" ]] ; then
restart_lnd
fi

if [[ $1 != skipsuccess ]] ; then
success "LND" "having Tor-only reversed"
fi
}

function watchtower_toggle {

if ! grep -q "watchtower=true" $pc ; then

yesorno "For information on watchtowers, see GitHub:
$cyan
    https://github.com/lightningnetwork/lnd/blob/master/docs/watchtower.md
$orange
    Parmanode will enable your LND node to act as a watchtower for others.

    BTW, it doesn't make sense to be your own watchtower in the same 
    network, because you have a watchtower in case your network goes down.

    Once you enable it, you need to share your public key (you'll see
    it later) with others so they can connect to it. You then generously
    supply your 'uptime' and the node monitors transactions for them,
    punishing attackers as needed.

    Do it?" || return 1

externalIP=$(get_external_IP)
debug "externalIP"

#delete old
gsed -i '/^watchtower.active/d' $lndconf
#add under [watchtower]
gsed -i '/\[watchtower\]/a\
watchtower.active=1' $lndconf
debug "1"
#add under watchtower.active=1
yesorno "Also enable clearnet access to your watchtower on IP:
$cyan
    $externalIP $orange?
    " && gsed -i "/watchtower\.active=1/a watchtower.externalip=$externalIP" $lndconf
         
parmanode_conf_add "watchtower=true"
success "Watchtower settings enabled"

else

yesorno "Disable watchtower settings?" || return 1
gsed -i '/watchtower.active/d' $lndconf
gsed -i '/watchtower.externalip/d' $lndconf
parmanode_conf_remove "watchtower=true"
success "Watchtower settings disabled"
fi
}