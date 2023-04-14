function IP_address {

IP=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}')

echo "
########################################################################################


    Your computer's IP address is:                                $IP



    Your computer's "self" IP address is:                         127.0.0.1



    For reference, every computer's default self IP address is    127.0.0.1 


########################################################################################
"
enter_continue
return 0
}

