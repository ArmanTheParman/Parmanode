function preamble_install_electrs_docker {
log "electrsdkr" "preamble install electrs docker"
while true ; do
set_terminal
echo -e "
########################################################################################
    
    Parmanode will now install$cyan ELECTRS$orange on your system inside a Docker container.

    The electrs code will be downloaded inside the container, then compiled. This 
    might take 10 to 30 minutes, depending on the speed of your computer.

    PROCEED?
$green
                        y)      Yes please, this is amazing
$red
                        n)      Nah mate
   $orange 
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