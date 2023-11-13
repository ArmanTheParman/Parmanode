function preamble_install_electrs {
while true ; do
set_terminal
echo "
########################################################################################
    
    Parmanode will now install ELECTRS on your system inside a Docker container.

    The electrs code will be downloaded inside the container, then compiled. This 
    might take 10 to 30 minutes, depending on the speed of your computer.

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
esac 
done 
}