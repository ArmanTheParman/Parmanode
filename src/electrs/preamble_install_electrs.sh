function preamble_install_electrs {
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
return 0
}