function create_account_btcpay {
#The code runs fine but I can't get it to make a new BTC account``
#Keeping it for future reference
while true ; do
set_terminal ; echo "
########################################################################################

                                BTCPay Admin Account
    
    Would you like to create a BTCPay admin account?

                  y)     Oh, yes, goodie

                  n)     Nah, I only installed BTCPay to LARP

########################################################################################
"
choose "x" ; read choice
case $choice in 
y|Y|Yes|YES|yes)
break ;;
n|N|No|NO|no)
return 0
;;
*)
invalid
;;
esac
done

set_terminal ; echo "
########################################################################################

    Enter your email (will be your username): " ; read email

echo "    Enter your password: " ; read password

otp="FreeRoss-"
otp=${otp}$(openssl rand -hex 6 | base64 | head -c 6)

echo "
########################################################################################

    Your email/username is: $email

    Your password is: $password

    Your one time password (case sensitive) is: $otp

########################################################################################

Accept (y) or try again (n) ?" ; read choice


docker exec -it -u root btcpay /bin/bash -c "echo \"Main:email=$email;password=$password;otp=$otp\" \\
| tee -a $HOME/.btcpayserver/Main/settings.config >/dev/null 2>&1"
}
