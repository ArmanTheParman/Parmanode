function electrs_ask_skip_dependencies {
while true ; do
set_terminal ; echo -e "
########################################################################################

    Parmanode has detected that you have previously started the electrs install 
    process on the Mac and went through the long painful process of updating the 
    computer, and building all the dependencies.

    You don't have to do that again, unless you want to.
$green
    Do it again?

                  y)       Why not, I'm going to live forever, I have time                  
    
                  n)       Time is Satoshis

########################################################################################
"
choose "xpq" ; read choice
case $choice in
q|Q) exit ;;
p|P) return 1 ;;
y|Y|YES|Yes|yes) 
export electrs_skip_dependencies=false
break ;;
n|NO|no|No|N) 
export electrs_skip_dependencies=true
break ;;
*) invalid ;;
esac
done


}