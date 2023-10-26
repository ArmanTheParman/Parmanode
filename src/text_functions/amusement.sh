function dirty_shitcoiner {

while true
do
set_terminal
echo -n "
########################################################################################
########################################################################################

             Shame on you. We're on the battle field, fighting tyranny, and
             you're using vital weapons to shoot ducks. Don't be a traitor to 
             your descendents and humanity. Stack bitcoin and help end tyranny.
		     
             Here's some reading material to help you understand...


     1) Why Bitcoin Only           
                                    - http://www.armantheparman.com/why-bitcoin-only 
     2) Why money tends towards one
                                    - http://www.armantheparman.com/onemoney

     3) We are separating money and state - Join us
                                    -  http://www.armantheparman.com/joinus
     4) Debunking Bitcoin FUD
                                    - http://www.armantheparman.com/fud

    
     Have a nice day.
    $cyan                
     To abort, type: (I'm sorry), then hit <enter>                 
$orange
########################################################################################
######################################################################################## 
"                  
read repent

if [[ $repent == "I'm sorry" ]] ; then 
        break 
    else    
        set_terminal 
        echo "Please wait patiently for computer to destroy itself, mwahaha!"
        echo "Or, hit <enter> to have another go." 
        read 
        set_terminal
        continue 
    fi

done

return 0
}
