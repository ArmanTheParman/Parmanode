function preamble_install_electrs_podman {
log "electrsdkr" "preamble install electrs podman"
while true ; do
set_terminal
echo -e "
########################################################################################
    
    Parmanode will now install$cyan ELECTRS$orange on your system inside a Docker container.

    The electrs code will be downloaded inside the container, then compiled. This 
    might take 10 to 30 minutes, depending on the speed of your computer.

    It should be much faster if this is not your computer's fist time 
    (installing electrs ;P).

    PROCEED?
$green
                        y)      Yes please, this is amazing
$red
                        n)      Nah mate
   $orange 
########################################################################################
"
choose xpmq ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
n|No|nah|NO|no) return 1 ;;
y|yes|YES|Yes|yeah|shit_yeah) break ;;
*) invalid ;;
esac 
done 
}