function make_home_parmanode {

#make $HOME/parmanode

if [[ -d $HOME/parmanode/ ]] # if -d to check that parmanode directory exists
then
while true #start menu loop
do
set_terminal
echo "
########################################################################################

    The directory $HOME/parmanode/ already exists on your computer.

########################################################################################

            d)          Delete the directory and contents, and start over

            u)          Uninstall Parmanode (before attempting install again) 

            p)          Abort to the previous menu

            yolo)       Push ahead with the existing directory (errors may occur)

########################################################################################
"
choose "xq"

        read choice
        set_terminal 
        case $choice in
        d|D)
            rm -rf $HOME/parmanode/ >/dev/null 2>&1
            ;;
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


mkdir $HOME/parmanode > /dev/null 2>&1 
#first point the drive is modified during the installation; noted in config file.

return 0
}
