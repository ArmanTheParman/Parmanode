function menu_sparrow {
if ! grep -q "sparrow-end" $ic ; then return 0 ; fi
while true ; do 
set_terminal
unset sversion
if [[ $OS == Mac ]] ; then
sversion=$(/Applications/Sparrow.app/Contents/MacOS/Sparrow --version | grep -Eo '[0-9].+$')
else
sversion=$($hp/Sparrow/bin/Sparrow --version | grep -Eo '[0-9].+$')
fi

if [[ $sversion != "2.1.1" ]] ; then 
    debug "sversion... $sversion"
    newversiontext="${pink}                    usp)          Update sparrow$orange\n"
    updateavailable="true"
fi


if [[ $OS == "Linux" ]] && [[ ! -e $HOME/Desktop/run_sparrow.sh ]] ; then
    shortcut="$cyan\n                  (dsk) $orange          Add Desktop Shortcut$red$blinkon NEW$blinkoff$orange\n"
else
    unset shortcut
fi
source $HOME/.parmanode/sparrow.connection >$dn

set_terminal_high ; echo -en "
########################################################################################
                  $cyan         Sparrow Menu -- Version $sversion                  $orange      
########################################################################################


               CURRENT SPARROW CONNECTION TYPE: $cyan$connection$orange

$green
                  start) $orange         Start Sparrow 
$red
                     mm) $orange         Manage node connection...
$shortcut$cyan
                     sc) $orange         View/Edit config file (scv for vim)
$cyan
                      t) $orange         Troubleshooting info
$cyan
                      w) $orange         Show saved wallet files
$cyan
                     cl) $orange         Clear connection certificates 
                       
$newversiontext

########################################################################################
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in 

m|M) back2main ;; q|Q|QUIT|Quit) exit 0 ;; p|P) menu_use ;; 

start|Start|START|S|s)
check_SSH || return 0
run_sparrow
return 0 ;;

mm|MM)
sparrow_connection_menu 
;;
dsk)
lsb_release -a 2>/dev/null | grep -q Ubuntu && announce "Won't work, Ubuntu doesn't allow desktop icons." && continue

cat <<'EOF' >$HOME/Desktop/run_sparrow.sh
#!/bin/bash
$HOME/parmanode/Sparrow/bin/Sparrow
EOF
sudo chmod +x $HOME/Desktop/run_sparrow.sh >$dn
success "Desktop Shortcut added. Double click and choose 'run' to run it."
;;
sc|SC|Sc)
echo -e "
########################################################################################
    
        This will run Nano text editor to edit 
$cyan 
        $HOME/.sparrow/config
$orange    
        See the controls at the bottom to save and exit. Be careful messing around 
        with this file.

        Any changes will only be applied once you restart Bitcoin.
$cyan
        Note, every time you change the sparrow connection type from the Parmanode
        menu, the config file will be replaced/refeshed.
$orange
########################################################################################
"
enter_continue ; jump $enter_cont
nano $HOME/.sparrow/config
continue
;;
scv|SCV)
vim_warning ; vim $HOME/.sparrow/config
;;

t|T)
troubleshooting_sparrow
;;

cl)
clear_sparrow
;;

w|W)
set_terminal_high
echo -e "
########################################################################################


    Directory:$cyan $HOME/.sparrow/wallets/ $orange


    Files: $bright_blue

$(ls $HOME/.sparrow/wallets)

$orange
########################################################################################
"
enter_continue ; jump $enter_cont
set_terminal
;;

usp)
[[ $updateavailable != "true" ]] && continue
update_sparrow
;;
"")
continue ;;
*)
invalid
;;

esac
done
}

function sparrow_connection_menu {
while true ; do
source $HOME/.parmanode/sparrow.connection >$dn
set_terminal
echo -e "
########################################################################################
$cyan
                            SPARROW CONNECTION OPTIONS  $orange

########################################################################################

                          
               CURRENT SPARROW CONNECTION TYPE: $cyan$connection$orange


$cyan                d)  $orange     Bitcoin Core via tcp (default)

$cyan                fs)   $orange   Fulcrum via ssl (port 50002)

$cyan                ft)    $orange  Fulcrum via tcp (port 50001)

$cyan                ftor) $orange   Fulcrum via Tor (port 7002)

$cyan                et)    $orange  electrs via tcp (port 50005)
                
$cyan                es)   $orange   electrs via SSL (experimental at this stage)

$cyan                xs)   $orange   ElextrumX via ssl (port 50008)

$cyan                xt)    $orange  ElextrumX via tcp (port 50007)

$blue                etor)    electrs via Tor (port 7004) 

$blue                rtor)    To a remote Electrum/Fulcrum server via Tor (eg a friend's)
$orange 

########################################################################################
"
choose xpmq ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 0 ;; m|M) back2main ;;

d|D)
make_sparrow_config
return 0
;;

ftor)
sparrow_fulcrumtor
return 0
;;

etor)
sparrow_electrstor
return 0
;;

fs)
make_sparrow_config "fulcrumssl"
return 0
;;

ft)
make_sparrow_config "fulcrumtcp"
return 0
;;

rtor|Rtor|RTOR)
sparrow_remote
return 0
;;

et)
make_sparrow_config "electrstcp"
return 0
;;

es)
make_sparrow_config "electrsssl"
return 0
;;


xt)
make_sparrow_config "electrumxtcp"
return 0
;;
xs)
make_sparrow_config "electrumxssl"
return 0
;;

*)
invalid
;;
esac
done
}


function update_sparrow {

announce "It's not always necessary to update Sparrow every time there is an 
    incremental update, but you can. It's best to only do it via Parmanode, 
    as it will verify the download for you. If you want to do it yourself, 
    you can, but Parmanode might get confused.

    To update to the latest version, uninstall Sparrow with Parmanode (your 
    wallets will not be delted), then install it again, and you'll have the 
    newer version."
}