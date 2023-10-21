#Linux, then Mac
function preamble_install_electrs {
if [[ $OS == Linux ]] ; then
while true ; do
set_terminal
echo "
########################################################################################
    
    Parmanode will now install ELECTRS on your system.

    Please note, you may be prompted to install cargo, a necessary program to compile
    electrs from source code. If you see an option to choose 1, 2, or 3, you need to
    select 1 to continue the installation.

    Also note, that because this is going to be compiled, no hash or gpg verification
    is necessary. This is because you are not trusting anyone per se, except that 
    the code is open source, and probably has had many eyes laid upon it. You are 
    of course free to read the code yourself to be sure. 

    This might take 10 to 30 minutes, depending on the speed of your computer.

    PROCEED?

                        y)      Yes please, this is amazing

                        n)      Nah mate
    
########################################################################################
"
read choice
case $choice in
n|No|nah|NO|no) return 1 ;;
y|yes|YES|Yes|yeah|shit_yeah) break ;;
*) invalid ;;
esac ; done ; set_terminal
fi
if [[ $OS == Mac ]] ; then

set_terminal 
echo -e "
########################################################################################

    WARNING: This can take a really long time on a Mac.

    Go ahead?      y    or    n

########################################################################################
"
read choice
if [[ $choice != y ]] ; then return 1 ; fi

clear
echo -e "
########################################################################################

    No, seriously, a REALLY long time.

    y    or   n

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
enter_continue

fi
}