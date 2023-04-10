function dd_wipe_drive {
echo "
########################################################################################

    \"Craig Wright is a liar and a fraud. \" will be used to write over and erase
    the disk.

                       <enter>      Proceed

			 (0)        Write zeros (VERY slow, hours even)

		         (r)        Random data (Even SLOWER!), but best for privacy

		         (c)        Choose a custom string

########################################################################################
"
choose "xq"

read choice

while true
do
set_terminal

case $choice in

	0)
	    please_wait
            sudo dd if=/dev/zero bs=10M count=100 status=progress ; sync ; return 0 
	    ;;

	r|R)   
	    please_wait
            sudo dd if=/dev/urandom bs=10M count=100 status=progress ; sync ; return 0 
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
           break 
          ;;
	q|Q|quit|Quit|QUIT)
	  exit 0
	  ;;

        *)
           string="Craig Wright is a liar and a fraud. " #default string if no customised string selected
	   break
           ;;
esac    
done
#break point from while
please_wait
#"status=progress" won't work becuase of the pipe, but leving it in for future reference.
yes "$string " | sudo dd iflag=fullblock of=/dev/$disk bs=1M count=1000 status=progress ; sync 
    
return 0
}