function check_port_conflicts_public_pool {

if [[ $OS == Linux ]] ; then
    if ! which netstat >/dev/null ; then sudo apt-get update -y && sudo apt-get install net-tools ; fi
fi

#dont' use -p option, then works on Mac too
if sudo netstat -tuln | grep -qE ':3333[^0-9]' ; then
while true ; do
set_terminal ; echo -e "
########################################################################################

    Parmanode is configured to assign port$cyan 3333$oange for this installation, but has
    detected that port 3333 is already asigned. This is likely to cause problems.

    You have choices.
$red
                      y)     yolo it and keep going
$green
                      a)     Abort, fix something yourself, and try again.
$orange
########################################################################################                    
"
choose "xpmq" ; read choice
set_terminal
case $choice in
q|Q) exit 0 ;; p|P|M|m|a) back2main ;;
y) 
break
;;
*)
invalid
;;
esac
done
fi

if sudo netstat -tuln | grep -qE ':3334[^0-9]' ; then
while true ; do
set_terminal ; echo -e "
########################################################################################

    Parmanode is configured to assign port$cyan 3334$oange for this installation, but has
    detected that port 3334 is already asigned. This is likely to cause problems.

    You have choices.
$red
                      y)     yolo it and keep going
$green
                      a)     Abort, fix something yourself, and try again.
$orange
########################################################################################                    
"
choose "xpmq" ; read choice
set_terminal
case $choice in
q|Q) exit 0 ;; p|P|M|m|a) back2main ;;
y) 
break
;;
*)
invalid
;;
esac
done
fi



if sudo netstat -tuln | grep -qE ':5050[^0-9]' ; then
while true ; do
set_terminal ; echo -e "
########################################################################################

    Parmanode is configured to assign port$cyan 5050$oange for this installation, but has
    detected that port 5050 is already asigned. This is likely to cause problems.

    You have choices.
$red
                      y)     yolo it and keep going
$green
                      a)     Abort, fix something yourself, and try again.
$orange
########################################################################################                    
"
choose "xpmq" ; read choice
set_terminal
case $choice in
q|Q) exit 0 ;; p|P|M|m|a) back2main ;;
y) 
break
;;
*)
invalid
;;
esac
done
fi



if sudo netstat -tuln | grep -qE ':5051[^0-9]' ; then
while true ; do
set_terminal ; echo -e "
########################################################################################

    Parmanode is configured to assign port$cyan 5051$oange for this installation, but has
    detected that port 5051 is already asigned. This is likely to cause problems.

    You have choices.
$red
                      y)     yolo it and keep going
$green
                      a)     Abort, fix something yourself, and try again.
$orange
########################################################################################                    
"
choose "xpmq" ; read choice
set_terminal
case $choice in
q|Q) exit 0 ;; p|P|M|m|a) back2main ;;
y) 
break
;;
*)
invalid
;;
esac
done
fi


if sudo netstat -tuln | grep -qE ':5052[^0-9]' ; then
while true ; do
set_terminal ; echo -e "
########################################################################################

    Parmanode is configured to assign port$cyan 5052$oange for this installation, but has
    detected that port 5052 is already asigned. This is likely to cause problems.

    You have choices.
$red
                      y)     yolo it and keep going
$green
                      a)     Abort, fix something yourself, and try again.
$orange
########################################################################################                    
"
choose "xpmq" ; read choice
set_terminal
case $choice in
q|Q) exit 0 ;; p|P|M|m|a) back2main ;;
y) 
break
;;
*)
invalid
;;
esac
done
fi




}

