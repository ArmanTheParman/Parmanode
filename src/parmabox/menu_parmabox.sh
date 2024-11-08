function menu_parmabox {
while true ; do 

if ! docker ps >$dn 2>&1 ; then
    dockerrunning="
                              ${red}Warning: Docker is not running${orange}
    "
else

   if ! docker ps | grep -qi parmabox ; then
   dockerrunning="
                              ${red}Warning: ParmaBox container is not running${orange}
   " 
   else
   dockerrunning="
                              ${green}ParmaBox is running${orange}
   " 
   fi

fi

set_terminal ; echo -ne "
########################################################################################
              $cyan                     ParmaBox Menu            $orange                   
########################################################################################

                              $dockerrunning 
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
choose "xpmq" ; read choice ; set_terminal
case $choice in 
m|M) back2main ;;
q|Q|QUIT|Quit) 
exit 0 ;;
p|P) menu_use ;; 
r|R) 
docker exec -it -u root parmabox /bin/bash ;;
pm) 
docker exec -it -u parman parmabox /bin/bash ;;
s) 
stop_parmabox ;;
rs) 
start_parmabox ;;
u) 
docker exec -it -u root parmabox bash -c "apt update -y && apt -y upgrade" 
echo "Update Parmanode..."
docker exec -it -u parman parmabox bash -c "cd /home/parman/parman_programs/parmanode ; git pull"
sleep 2
;;
rf)
parmabox_refresh
;;
*)
invalid
;;

esac
done
} 

function start_parmabox {
docker start parmabox >$dn 2>&1
}
function stop_parmabox {
docker stop parmabox >$dn 2>&1
}