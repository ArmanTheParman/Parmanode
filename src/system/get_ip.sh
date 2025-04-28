function get_external_IP { curl -s ifconfig.me ; }

function get_ip_address {

if [[ $(uname) == "Linux" ]] ; then

    if ! which ip >$dn 2>&1 ; then
        clear
        enter_continue "Installing necessary ip function (iproute2)..."
        sudo apt-get update -y && sudo apt-get install iproute2 -y
    fi

    if [[ -e /.dockerenv ]] ; then #docker container detected
        export IP=$( ip a | grep "inet" | grep 172 | awk '{print $2}' | cut -d '/' -f 1 | head -n1 )
    else 
        export IP=$( ip a | grep "inet " | grep -v 127.0.0.1 | grep -v 172.1 | awk '{print $2}' | cut -d '/' -f 1 | head -n1 )
    fi
fi

if [[ $(uname) == "Darwin" ]] ; then export IP=$( ifconfig | grep "inet " | grep -v 127.0.0.1 | grep -v 172.1 | awk '{print $2}' | head -n1 ) ; fi
# Through a series of searches (grep), the results being passed by the | symbol to the right and being
# searched on again, the results are narrowed down.
# awk is used to print out a field (like selecting a column in an excel row), and cut
# can split text according to a delimeter (-d) and choosing a resulting field (-f)
}

function IP_address {
count=0
while [[ $count -lt 3 ]] ; do 
export external_IP=$(curl -s ifconfig.me)
count=$((count+1))
parmanode_conf_remove "external_IP"
parmanode_conf_add "external_IP=$external_IP"
source $pc || { sleep 2 ; continue ; }
break
done


source $pc || { parmanode_conf_remove "external_IP" ; }

if [[ $1 == get ]] ; then
return 0
fi

#IP variable is printed for the user.
if [[ $OS == Linux ]] ; then
message="    You can actually change the hostname of this computer. Just edit the name 
    in the file /etc/hostname. For example if you put 'parmanode' in there, just a 
    single line of text, then you can access the computer with:
$cyan
       ssh $USER@parmanode.local $orange

    Cool huh? I think it's cool."
else
unset message
fi



set_terminal 46 88
echo -e "
########################################################################################


    Your computer's IP address is:                   $cyan             $IP $orange


    Your computer's \"self\" IP address should be:                  127.0.0.1


    For reference, every computer's default self IP address is    127.0.0.1 
                                                            and   localhost


    To access this computer from another computer ON THE SAME NETWORK, you can type 
    in the terminal of the other computer (even Windows):
$green
        ssh $USER@$IP
$orange
    ssh needs to be enabled on this system (it usually is by default).

    If you really want to use Windows (eww) to access this computer by ssh, you'll
    have to install a program called Putty on the Windows machine.
$bright_blue
    The EXTERNAL IP for your router (Your Home's IP not just this device):

$green                                                                   $external_IP  $orange

$message

########################################################################################
"
enter_continue ; jump $enter_cont
return 0
}