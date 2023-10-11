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
		     
                Here's some reading material to help you understand. If the links
                do not allow you to click, just copy and paste them in a browser.
            
                            1) "
printf "\e]8;;%s\a%s\e]8;;\a" "http://www.armantheparman.com/why-bitcoin-only" "Why Bitcoin Only"
echo -n "
                            2) "
printf "\e]8;;%s\a%s\e]8;;\a" "http://www.armantheparman.com/onemoney" "Why money tends towards one (with proof)"
echo -n "
                            3) "
printf "\e]8;;%s\a%s\e]8;;\a" "http://www.armantheparman.com/joinus" "We are separating money and state - Join us."
echo -n "
                            4) "
printf "\e]8;;%s\a%s\e]8;;\a" "http://www.armantheparman.com/fud" "Debunking Bitcoin FUD"
echo "

                 Have a nice day.
                    
		 To abort, type: (I'm sorry), then hit <enter>                 

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
        continue 
    fi

done

return 0
}
