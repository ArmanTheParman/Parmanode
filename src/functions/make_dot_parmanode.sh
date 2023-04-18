function make_dot_parmanode {

#make parmanode hidden directory
if [[ -d $HOME/.parmanode ]] 
then
	while true
	do
	set_terminal
	echo "
########################################################################################

                      The .parmanode direcotry already exists

    It seems you are trying to re-install parmanode. It's better to fully uninstall
    Parmanode (u) before proceeding. Or type (yolo) to continue (the .parmanode 
    directory will be replaced).

########################################################################################
"
choose "x" ; read choice
	
	case $choice in
	q)
        exit 0 ;;
        
    yolo|YOLO)
        rm -rf $HOME/.parmanode && mkdir $HOME/.parmanode 
        break ;;

	*)
        invalid
        read ;;
        esac
    done
    
else 
    mkdir $HOME/.parmanode 

fi # end of checking $HOME/.parmanode existence

installed_config_add "parmanode-start" >/dev/null 

return 0
}