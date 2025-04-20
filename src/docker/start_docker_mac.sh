function start_docker_mac {

( nohup open -a "Docker Desktop" >$dn 2>&1 & nohup_exit_status=$?; exit $nohup_exit_status ) && log "docker" "docker open -a nohup" \
|| log "docker" "docker failed to nohup open -a" 

while true ; do
if docker ps >$dn 2>&1  ; then return 0 ; fi
set_terminal ; echo -e "
########################################################################################
$cyan
                                Docker is starting...
$orange                       
    Docker should be loading; it sometimes could take a minute or so. There may be a
    graphical pop-up - make sure to accept the terms and conditions if that appears,
    otherwise Parmanode (& Docker) will not work. 

    If there's a problem after a few minutes, try starting Docker yourself. If you
    still have issues installing Docker using Parmanode, try installing Docker
    manually yourself. Parmanode will detect it and use it.
    
    After accepting the terms,$cyan you can close the Docker window. $orange

    If Parmanode doesn't successfully install Docker, and you fail to as well, then
    carefully place the computer in the bin and buy a new one, preferably Linux, 
    not Mac, and not, God forbid, Windows.

$green
               ####################################################
                 HIT <ENTER> ONCE YOU CONFIRMED DOCKER IS RUNNING 
               ####################################################
$orange

########################################################################################
"
choose "epq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in 
Q|q|Quit|QUIT) exit 0 ;; p|P) set_terminal ; return 1 ;; *) set_terminal ; continue ;; 
esac 
done
}
