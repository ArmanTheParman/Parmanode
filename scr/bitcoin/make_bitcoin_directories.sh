
function make_bitcoin_directories {
drive=$1


#has the bitcoin directory on parmanode been made? If not, make it.
    parmanode_bitcoin_directory             
                                        


# If external drive - create necessary directories 

external_drive_directories              
    # calls format_choice
    # calls delete_dot_bitcoin_directory (+/- make_backup_dot_bitcoin_director)
    # calls set_dot_bitcoin_symlink
                                                                              
                                   
#Internal drive - create directories, and back up if existing.
internal_drive_directories
    # check if drive is internal
    # give user options if .bitcoin exists
    # option to call make_bakcup_dot_bitcoin
    # abort bitoin installation if return 1
    if [[ $? == 1 ]] ; then return ; fi 
return 0
}

function parmanode_bitcoin_directory {

if [[ -d $HOME/parmanode/bitcoin ]] 
then 
            rm -rf $HOME/parmanode/bitcoin/* > /dev/null 2>&1
else
            mkdir $HOME/parmanode/bitcoin > /dev/null 2>&1
fi

installed_config_add "bitcoin-start"
#First significant install "change" made to drive

return 0
}


########################################################################################

function external_drive_directories {
debug_point "entered external drive directories"
if [[ $drive == "external" ]]
    then
    format_choice                           # a chance to format drive again if not done before.
                                            # if .bitcoin exists, and, isn't a symlink, user 
                                            # to decide to wipe or back up.
                                            # create symlink later. Double check.
delete_dot_bitcoin_directory                                        
    debug_point "about to make symlink"
set_dot_bitcoin_symlink


fi
return 0
}

########################################################################################

function internal_drive_directories {

if [[ $drive == "internal" ]]
then true
else return 1
fi

# If .bitcoin directory exists, decide what to do with it.
# If it doesn't exists, do nothing, running bitcoind will create it automatically.

if [[ -d $HOME/.bitcoin ]]
then 

while true #menu loop
do
set_terminal
echo "
########################################################################################

           $HOME/.bitcoin (Bitcoin data directory) already exists

    Would you like to:

            (d)         Start fresh and delete the files/directories contained 
                        within

            (yolo)      Use the existing .bitcoin data directory (be careful)

            (b)         Make a backup copy as ".bitcoin_backup", and start fresh

    If using the existing directory (yolo), be aware Parmanode might make changes 
    to its contents, and you could get unexpected behaviour.       

########################################################################################
"     
choose "xq"

read choice

set_terminal

case $choice in

    d|D) #delete
        rm -rf $HOME/.bitcoin/
        echo ".bitcoin directory deleted."
        enter_continue
        break
        ;;

    yolo|YOLO) #use existing .bitcoin directory and contents
        echo "
        Using exiting .bitcoin directory"
        enter_continue
        break
        ;;

    b|B) #back up directory
        make_backup_dot_bitcoin                 #original directory deleted by a "move"
        break
        ;;

    q|Q|quit|QUIT)
        exit 0
        ;;
        
    *)
        invalid
        continue ;;
esac

done 
else
    mkdir $HOME/.bitcoin >/dev/null 2>&1
fi 
return 0
}



function format_choice {
set_terminal
echo "
########################################################################################

                    Format drive? (y) (n)
                
                    You don't have to if you've already done this.

########################################################################################
"
choose "xq"
read choice
if [[ $choice == "y" ]] ; then format_ext_drive ; set_terminal ; fi
return 0
}

########################################################################################



function delete_dot_bitcoin_directory {                        
#.bitcoin will be deleted if it exists and is not a symlink.

if [[ -d "$HOME/.bitcoin" && ! -L "$HOME/.bitcoin" ]]        
then
debug_point " .bitcoin proper directory exists"
while true
do
set_terminal
echo "
########################################################################################

    The directory:
    
                $HOME/.bitcoin
    
    currently already exists on your internal drive. It has a size of: 
    
                $(du -sh $HOME/.bitcoin | cut -f1)

    Even though you are using an external drive for the Bitcoin data directory,
    this internal drive's directory is needed to "direct traffic" to the external 
    drive by a symlink, also known as a "shorcut" to Windows users.

    To continue with an external drive, the .bitcoin directory needs to either be 
                        
                        deleted (d)  ----> reckless?

                        backed up (b) and renamed to .bitcoin_backup. 

    A symlink to the external drive will be created in its place and named
    $HOME/.bitcoin.

    Note that the \".\" in front of bitcoin means it's a hidden directory.

    The backup you make can be deleted later. If you know what you're doing, you can 
    move the backup directory to the original location to use that copy of the 
    blockchain data should you ever need.

########################################################################################
"
choose "xq"
read choice
set_terminal

    case $choice in
        d)                                      #User chooses to delete existing data directory.
            sudo rm -rf $HOME/.bitcoin 
            break
            ;;
        b)                                      #User chooses to back up existing data directory, and original is deleted.
            make_backup_dot_bitcoin             
            break
            ;;
        *)
            invalid
            ;;

        q | quit | Q)
            exit 0
            ;;
        esac

done 
else
    true # nothing do do, there should be no .bitcoin in the HOME directory. Will make symlink later.
fi     


return 0
}



function set_dot_bitcoin_symlink {
debug_point "entered set dot bitcoin symlink"
set_terminal

#check there is a drive mounted, then make .bitcoin directory on external drive.
while true
do
echo "
########################################################################################

                             Preparing External Drive

    
    Please make sure your external drive is connected before proceeding. It needs 
    to be connected, and needs a few seconds to mount to:

                           /media/$(whoami)/parmanode/

    This should all work automoatically, but not everything can be anticipated. 

    OPTIONAL: 

    If you get an error, you can manually open a new terminal window (after 
    connecting the drive), and start by searching for the drive ID. Type:

                                    lsblk
                            or
                                    sudo lsblk
            
    You will get a readout of your drives. When you identify the right one, make a 
    note of its ID, eg: /dev/sdb or /dev/sdc etc. Then, making sure your current 
    directory is not the mount point, run this command:

                 sudo mount /dev/sdb /media/$(whoami)/parmanode/
            
    Make sure to use the correct drive ID. I have used sdb as an example. Once you do
    that, you can return to this program and retry.

########################################################################################
"
enter_continue
mount_drive
    if [ $? == 0 ] ; then
    break
    fi
done
# make a symlink on internal drive (.bitcoin should not exist there at this point)

    rm $HOME/.bitcoin #removes symlink if it exists. Can't remove directory becuase no -r option.

    cd $HOME && ln -s /media/$(whoami)/parmanode/.bitcoin/ .bitcoin     
    if [[ -d $HOME/.bitcoin ]] ; then debug_point ".bitoin made" ; else debug_point "failed to make .bition" ; fi
    #symlink can be made withouterrors even if target doesn't exist yet.

set_terminal
echo "
########################################################################################

    A symlink (\"shortcut\") has been created pointing $HOME/.bitcoin, the default 
    Bitcoin Core data directory, to your external drive.

########################################################################################
"
enter_continue
return 0
}

function mount_drive {

    #if mounted, make .bitcoin and exit 0
	    if mountpoint -q "/media/$(whoami)/parmanode" ; then
		mkdir /media/$(whoami)/parmanode/.bitcoin > /dev/null 2>&1 
		# potentially redundant depending on which function calls but no harm if the directory exits.
		return 0

    # Otherwise, try mounting with label, then UUID, then loop.
	    else
		set_terminal
		echo "Drive not mounted. Mounting ... Hit (q) to abort."
		read choice ; if [[ $choice == "q" ]] ; then return 1 ; fi

		#try mounting
		sudo mount -L parmanode /media/$(whoami)/parmanode
			if mountpoint -q "/media/$(whoami)/parmanode" ; then return 0 ; fi

		sudo mount -U $UUID
			if mountpoint -q "/media/$(whoami)/parmanode" ; then return 0
			else sleep 3 ; debug_point "about to loop into mount drive " ; mount_drive ; fi  #calling self (loop)
	    fi

return 0
}

