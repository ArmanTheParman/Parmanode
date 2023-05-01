function ssl_port_change_fulcrum {    #called by fulcrum_to_remote function

while true ; do
set_terminal ; echo "
########################################################################################

                                    SSL port

    The standard port that Fulcrum server will use to communicate with wallets is
    50002. If you have more than one Fulcrum server, this will cause mass confusion
    and pandamonium. You can use port 50003 instead, but do remember to put the
    correct port in your wallet.

            2)           Change to 50002 

            yolo)        Change to 50003

            x)           Don't touch anything (skip)

########################################################################################
"
choose "xpq" ; read choice

case $choice in 

q|Q|QUIT|Quit) exit 0 ;; 

p|P) return 1 ;; 

2) 

if docker ps | grep fulcrum >/dev/null 2>&1 ; then
    { docker exec -d -u parman fulcrum /bin/bash -c \
    "source /home/parman/parmanode/src/edit_ssl_port_fulcrum_indocker.sh ; \
    edit_ssl_port_fulcrum_indocker 50002" \
    && log "fulcrum" "docker exec edit ssl port fulcrum indocker 50002 has run" && break ; } \
    || { log "fulcrum" "Failed to edit ssl port fulcrum indocker 50002" && return 1 ; }
else
    set_terminal ; echo "Fulcrum Docker container is not running - can't change SSL port to default, 50002. Aborting."
    log "fulcrum" "Unable to set SSL to 50002, fulcrum container not running."
    enter_continue
    return 1
fi
;;

yolo|YOLO|Yolo)

if docker ps | grep fulcrum >/dev/null 2>&1 ; then
    { docker exec -d -u parman fulcrum /bin/bash -c \
    "source /home/parman/parmanode/src/edit_ssl_port_fulcrum_indocker.sh ; \
    edit_ssl_port_fulcrum_indocker 50003" \
    && log "fulcrum" "docker exec edit ssl port fulcrum indocker 50003 has run" && break ; } \
    || { log "fulcrum" "Failed to edit ssl port fulcrum indocker 50003" && return 1 ; }
else
    set_terminal ; echo "Fulcrum Docker container is not running - can't change SSL port to 5003. Aborting."
    enter_continue
    return 1
fi
;; 

x|X) break ;;

*) invalid ;; 
esac

done

return 0
}