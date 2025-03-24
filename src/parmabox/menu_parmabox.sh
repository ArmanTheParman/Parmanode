function menu_parmabox {
if ! grep -q "parmabox-end" $ic ; then return 0 ; fi
while true ; do 
if ! podman ps >$dn 2>&1 ; then
    podmanrunning="
                              ${red}Warning: Docker is not running${orange}
    "
else

   if ! podman ps | grep -qi parmabox ; then
   podmanrunning="
                              ${red}Warning: ParmaBox container is not running${orange}
   " 
   else
   podmanrunning="
                              ${green}ParmaBox is running${orange}
   " 
   fi

fi

set_terminal ; echo -ne "
########################################################################################
              $cyan                     ParmaBox Menu            $orange                   
########################################################################################

                              $podmanrunning 
$cyan
            r) $orange        Log into the container as root
$blue                              The password is 'parmanode' 
$cyan
            pm)$orange        Log into the container as parman   (type exit to return here)
$blue                              The password is 'parmanode' 
$cyan
            s)$orange         Stop the container
$cyan
            rs)$orange        Restart the container
$cyan
            u)$orange         Run an update of Parmanode and the OS inside the container
$cyan
            rf)$orange        Refresh ParmaBox (starts over and includes new updates)

$orange

########################################################################################
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in 
m|M) back2main ;; q|Q|QUIT|Quit) exit 0 ;; p|P) menu_use ;; 
r|R) 
podman exec -it -u root parmabox /bin/bash ;;
pm) 
podman exec -it -u parman parmabox /bin/bash ;;
s) 
stop_parmabox ;;
rs) 
start_parmabox ;;
u) 
podman exec -it -u root parmabox bash -c "apt update -y && apt -y upgrade" 
echo "Update Parmanode..."
podman exec -it -u parman parmabox bash -c "cd /home/parman/parman_programs/parmanode ; git pull"
sleep 2
;;
rf)
parmabox_refresh
;;
"")
continue ;;
*)
invalid
;;

esac
done
} 

function start_parmabox {
podman start parmabox >$dn 2>&1
}
function stop_parmabox {
podman stop parmabox >$dn 2>&1
}