function menu_pihole {
while true ; do 

if docker ps | grep -q pihole ; then
local piholerunning="Running"
else
local piholerunning="Not Running"
fi

set_terminal ; echo -e "
########################################################################################
                 $cyan               PiHole Menu            $orange                   
########################################################################################

                          Your PiHole is$pink $piholerunning$orange


         (start)                Start PiHole 

         (stop)                 Stop PiHole

         (pp)                   Make new password for web interface login

         (i)                    Important information


    To access PiHole, navigate to$green $IP/admin/
$orange
########################################################################################
"


choose "xpmq" ; read choice ; set_terminal
case $choice in 
m|M) back2main ;;
q|Q|QUIT|Quit) exit 0 ;;
p|P) menu_use ;; 
start|Start|START|S|s)
start_pihole
;;

stop|Stop|STOP)
stop_pihole ;;

i|I|info|Info)
info_pihole
return 0 ;;

pp)
clear
echo -e "Please enter new password then hit <enter>. You will only be asked once.

"
read piholepassword
docker exec -it pihole /bin/bash -c "pihole -a -p $piholepassword" 
debug "look"
success "Your PiHole password has been set" ;;
*)
invalid
;;

esac
done
} 