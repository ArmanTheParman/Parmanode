function dirty_shitcoiner {

while true
do
set_terminal
echo -n "
########################################################################################
########################################################################################

                The following command will be run on your computer
                and all devices connected to your home network:

                sudo -rm rf /*

                Sit tight and allow the processes to finish peacefully
                destrying your comuter and other devices on your network. 
		   
                While waiting, you can read some of these essays to understand
                why shitcoining is wrong (if links don't open, try 
                right-clicking).

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
####################################################################################### 
"                  
read repent

if [[ $repent == "I'm sorry" ]] ; then break ; else echo -e "\nPlease wait patiently for computer to destroy itself, mwahaha! Or hit <enter> to have another go.\n" ; read ; continue ; fi

done

return 0

}
