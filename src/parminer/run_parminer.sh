#!/bin/bash

clear
while true ; do

echo -e "
########################################################################################


    Please enter or type in your bitcoin address.

    Default value is: 14CvyafhmkPdhiAAA5mzpyDvuYPHtDjVws 
    

########################################################################################
<enter> to continue
"
read address
case $address in
q) exit ;;
"") 
address=14CvyafhmkPdhiAAA5mzpyDvuYPHtDjVws
esac

clear

echo -e "
########################################################################################

    Hit <enter> alone to extract user and password from bitcoin.conf, or type in
    your username, a space, then the password, then enter.

########################################################################################
"
read userpass

case $userpass in
q) exit ;;
"") 
user=$(grep rpcuser= $HOME/.bitcoin/bitcoin.conf | cut -d = -f 2)
password=$(grep rpcpassword= $HOME/.bitcoin/bitcoin.conf | cut -d = -f 2)
;;
*)
user=$(echo $userpass | cut -d ' ' -f 1)
password=$(echo $userpass | cut -d ' ' -f 2)
;;
esac

clear
echo -e "
########################################################################################

    Please enter a message to store to mark your territory on the block, max 100
    characters. <enter> alone for nothing.

########################################################################################    
"
read message

clear
echo -e "
########################################################################################


    Proposed data...

    address:           $address
    bitcoin username:  $user
    bitcoin password:  $password
    message:           $message

    proposed command:

        $HOME/parmanode/bfgminer/bfgminer -o http://localhost:8332 \\
        -u $user -p $password \\
	--generate-to $address \\
	--coinbase-sig "$message"

    <enter> to accept
    's' and <enter> to start over
    'q' and <enter> to quit

########################################################################################
"
read choice

case $choice in
q) exit ;;
s) continue ;;
*) break ;;
esac
done


$HOME/parmanode/bfgminer/bfgminer -o http://localhost:8332 -u $user -p $password --generate-to $address --coinbase-sig "$message"
