
function compatibility {
set_terminal ; echo -e "
########################################################################################

    Parmanode will download Bitcoin block data on your computer's internal drive or
    external drive. 


    Internal drive:                $HOME/.bitcoin   $green 
                                                           The . means the directory 
                                                           is hidden $orange

    External drive:                /.bitcoin
    
    External drive mount point:    /media/$USER/parmanode/.bitcoin
                                       $green 
                                   The drive is called \"parmanode\" and is
                                   mounted to /media/$USER and you can access
                                   it from there. $orange
                    
    You can copy the .bitcoin data to your other computer and it will continue to
    sync there.$pink It is absolutely vital that you stop Bitcoin before copying data
    or it's likely the data will be corrupted and you'll have to start all over
    again. $orange
    
    You can not just copy data from elsewhere and use it for Parmanode on your external
    drive - You also have to import the drive also from the tools menu.

    However, for internal drives, you can just copy data from another computer to
    $HOME/.bitcoin (make sure Bitcoin is stopped) then install Bitcoin with Parmanode.
    It will detect the data and promtp you to keep or discard it.

########################################################################################
"
enter_continue
}