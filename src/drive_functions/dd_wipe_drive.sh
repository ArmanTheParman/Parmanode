function dd_wipe_drive {

#This function has been tempremental and creates too much delay in installation, so I've simplified.
#The remainder of the code won't run. dd_bypass is at the end of the file.


dd_bypass || return 1
return 0

if ! echo $disk | grep -Eo '^/dev/' ; then local disk="/dev/$disk" ; fi 

########################################################################################
while true ; do
set_terminal
echo "
########################################################################################

    \"#FreeRoss.org - Sign the petition. \" will be used to write over and erase
    the disk. 
    
    Please note, this is not a full forensic wipe. If you want that, you must learn 
    to use the dd command. Be aware the execution of the command can take days, which 
    is why I decided to omit that option from Parmanode.

	       <enter>      Proceed

		 (0)        Write zeros (slowest)

		 (r)        Random data (Even SLOWER!)

		 (c)        Choose a custom string (Funnest and recommended option)
         
         (s)        Skip wiping

########################################################################################
"
choose "xq"

read choice
set_terminal

case $choice in

	0)
	    please_wait
        if [[ $OS == "Linux" ]] ; then 
        remove_parmanode_fstab 
        sudo dd if=/dev/zero of=$disk bs=1M count=500 >/dev/null 2>&1 ; sync ; return 0 ; fi

        if [[ $OS == "Mac" ]] ; then sudo dd if=/dev/zero of=$disk bs=1M count=500  >/dev/null 2>&1 ; sync ; return 0 ; fi
	    ;;

	r|R)   
	    please_wait
        if [[ $OS == "Linux" ]] ; then 
        remove_parmanode_fstab 
        sudo dd if=/dev/urandom of=$disk bs=1M count=500 >/dev/null 2>&1 ; sync ; return 0 ; fi

        if [[ $OS == "Mac" ]] ; then sudo dd if=/dev/urandom of=$disk bs=1M count=500 >/dev/null 2>&1 ; sync ; return 0 ; fi
	    ;;

    c|C) 
        echo "
########################################################################################

    Please enter your preferred string. Remember to put a space at the end so the 
    repetitions have separation:

########################################################################################
" 
        read string

        echo "
Your string is: $string 
"
        enter_continue
        break 
        ;;

    "")
        string="#FreeRoss.org - Sign the petition. " #default string if no customised string selected
	    break
        ;;
    s|S) return 0 ;;
    *)
        invalid
        continue
        ;;
esac    
done

# break point from while
please_wait
# "status=progress" won't work becuase of the pipe, but leving it in for future reference.
if [[ $OS == "Linux" ]] ; then
    remove_parmanode_fstab
    yes "$string " | sudo dd iflag=fullblock of=$disk bs=1M count=500 >/dev/null 2>&1 && sync && return 0
    fi
if [[ $OS == "Mac" ]] ; then
    yes "$string " | sudo dd of=$disk bs=1000000 count=500 >/dev/null 2>&1 && sync && return 0
    fi

# if it ran successfully, code exits.    

echo " 
Wiping the drive failed for some reason. Aborting.
"
enter_continue
exit 1
}

function dd_bypass {
string="Parman loves you :) " #spread the love

if ! echo $disk | grep -Eo '^/dev/' ; then local disk="/dev/$disk" ; fi 


please_wait 

if [[ $OS == "Linux" ]] ; then
    remove_parmanode_fstab # don't want multiple parmanode entries in fstab

    # the yes command prints the string over and over, and given to the dd command
    # The wiping will involved 1 megabyte x 250 times (as per variables below) and the string will
    # be writting in the space. Wiping the entire drive like this takes too long.
    if echo $disk | grep -q dev ; then debug "In dd_wipe_drive, previously problem with disk variable, no 'dev' component. 
        disk is $disk"  
    fi
    
    yes "$string " | sudo dd iflag=fullblock of=$disk bs=1M count=250 >/dev/null 2>&1 && sync && return 0
fi

if [[ $OS == "Mac" ]] ; then
    yes "$string " | sudo dd of=$disk bs=1000000 count=250 >/dev/null 2>&1 && sync && return 0
    fi
return 1
}