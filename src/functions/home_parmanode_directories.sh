function home_parmanode_directories {

if [[ -d $HOME/parmanode/ ]] #if to check that parmanode exists
then
while true #start menu loop
do
set_terminal
echo "
########################################################################################

    The directory $HOME/parmanode/ already exists on your computer.

########################################################################################

            u)          Uninstall Parmanode (before attemptin install again) 

            p)          Abort to the previous menu

            yolo)       Push ahead with the existing directory (errors may occur)

########################################################################################
"
choose "xq"

        read choice
        set_terminal 
        case $choice in
        u|U) 
            uninstall_parmanode # when done, expecting code to return here.
            return 1
            ;;
        p|P) #abort
            return 1 ;;
        yolo|YOLO) #proceed with merging
            break ;;
        q|Q|quit)
            exit 0
            ;;
        *)
            continue;;
        esac

break
done #end menu while loop
fi #end if internal directory parmanode exists.


mkdir $HOME/parmanode > /dev/null 2>&1 && installed_config_add "parmanode-start" >/dev/null 
#first point the drive is modified during the installation; noted in config file.

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
        break ;;

	*)
        invalid
        read ;;
        esac
done
#break point, "yolo", to delete and replace .parmanode
fi # end of checking $HOME/.parmanode existence

# If no .parmanode, or if yolo, rm then create.
rm -rf $HOME/.parmanode && mkdir $HOME/.parmanode 

return 0
}
