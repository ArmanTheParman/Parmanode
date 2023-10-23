function pls_connect_drive {
if mount | grep -q parmanode ; then return 0 ; fi

set_terminal ; echo -e "
########################################################################################

    Parmanode has detected that you already have a parmanode drive prepared for
    one of the three programs (Bitcoin, electrs, Fulcrum).

    Please attach the drive now and hit$cyan <enter>$orange once done, 
    
       OR
    
    ... type$cyan \"nah\"$orange and$cyan <enter>$orange

########################################################################################
"
read choice
if [[ $choice == nah ]] ; then return 1 ; fi

if mount | grep -q parmanode ; then return 0 ; fi

mount_drive menu || return 1 

return 0
}