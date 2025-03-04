#Linux, then Mac
function preamble_install_electrs {
if [[ $OS == Linux ]] ; then
while true ; do
set_terminal
echo -e "
########################################################################################
    
    Parmanode will now install$cyan ELECTRS$orange on your system.

    Because this is going to be compiled, no hash or gpg verification is necessary. 
    This is because you are not trusting anyone per se, except that the code is open 
    source, and probably has had many eyes laid upon it. You are of course free to 
    read the code yourself to be sure. 

    This might take 10 to 30 minutes, depending on the speed of your computer.
    
    It should be much faster if this is not your computer's fist time installing
    electrs. 

    PROCEED?
$green
                        y)      Yes please, this is amazing
$red
                        n)      Nah mate 
$orange
########################################################################################
"
choose xpmq
read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
n|No|nah|NO|no) return 1 ;;
y|yes|YES|Yes|yeah|shit_yeah) break ;;
*) invalid ;;
esac ; done ; set_terminal
fi

########################################################################################

if [[ $OS == Mac ]] ; then

set_terminal 
echo -e "
########################################################################################

    WARNING: This can take a really long time on a Mac.

    Go ahead?      $cyan y$orange    or    $cyan n$orange

########################################################################################
"
read choice
if [[ $choice != y ]] ; then return 1 ; fi

clear
echo -e "
########################################################################################

    No, seriously, a REALLY long time.

   $cyan y$orange    or  $cyan n$orange

########################################################################################
"
read choice
set_terminal
if [[ $choice != y ]] ; then return 1 ; fi

set_terminal

echo -e "
########################################################################################

    Okay buddy, you asked for it...

    Remember, from time to time, check on the computer in case your password is needed.
    
########################################################################################

"
enter_continue ; jump $enter_contq 
fi
}