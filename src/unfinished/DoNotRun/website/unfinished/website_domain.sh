function website_domain {
unset domain

while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                                   Domain Name
$orange

    Do you have a domain name to use with this website?

$cyan                     n)$orange           No, just use my local IP address 

$cyan                     y)$orange           Yes

$cyan                     t)$orange           Tell me how ...

########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in q|Q) exit 0 ;; p|P) return 1 ;; 
n|N|No|no) 
export domain="$IP"
return 0
;;
y|Y)
export domain_choice=true
break
;;
t|T)
export domain_choice=how
break
;;
*)
invalid
;;
esac
done

if [[ $domain == yes ]] ;; then
while true ; do
set_terminal ; echo -e "
########################################################################################

    Please type in your domain name, eg $cyan

        example.com
$orange    
    then$green <enter>$orange. If you have a 'www' prefix, you don't need to type that in here.

########################################################################################
"
choose "xpmq"
read domain ; set_terminal
case $choice in q|Q) exit 0 ;; p|P) return 1 ;;
"") continue
;;
*)
set_terminal ; echo -e "
You have chosen$cyan $domain

y and <enter> to accept, and anything else to try again.

"
read accept ; if [[ $accept == "" ]] ; then export domain ; break ; else continue ; fi
break
;;
esac
done

if ! echo $domain | grep -qE '^www.' ; then
while true ; do
set_terminal ; echo -e "
########################################################################################

    Would you like your domain with a 'www' prefix to also be accessible to visitors?

    y)     yes

    n)     no

########################################################################################
" ; choose "xpmq" ; read choice ; set_terminal
case $choice in q|Q) exit 0 ;; p|P) return 1 ;;
n|N|NO|No|no)
export www=false
break
;;
y|Y|Yes|yes)
export www=true
break
;;
*)
invalid
;;
esac
done

fi





}