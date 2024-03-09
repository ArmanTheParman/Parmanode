function website_domain {
unset domain

while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                                    Domain Name
$orange

    Do you have a domain name to use with this website?

$cyan                 n)$orange           No, just use my internal IP address 

$cyan                 e)$orange           No, just use my external IP address 

$cyan                 y)$orange           Yes, and configure it

$cyan                 t)$orange           Tell me how ...

########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in q|Q) exit 0 ;; p|P) return 1 ;; 
n|N|No|no) 
export domain="$IP"
return 0
;;
e|E)
export domain="$external_IP"
;;
y|Y)
export domain_choice=true
break
;;
t|T)
export domain_choice=how
#give info then exit
return 1
;;
*)
invalid
;;
esac
done

if [[ $domain == true ]] ; then
while true ; do
set_terminal ; echo -e "
########################################################################################

    Please type in your domain name, eg 
$cyan
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
You have chosen$cyan $domain $orange

${green} y$orange and$cyan <enter>$orange to accept, and anything else to try again.

"
read accept ; if [[ $accept == "" ]] ; then export domain ; break ; else continue ; fi
break
;;
esac
done
fi

if ! echo $domain | grep -qE '^www.' ; then
while true ; do
set_terminal ; echo -e "
########################################################################################

    Would you like your domain with a 'www' prefix to also be accessible to visitors?

                                ${green}y)$orange       yes

                                ${red}n)$orange       no

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