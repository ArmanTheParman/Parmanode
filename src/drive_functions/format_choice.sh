function format_choice {
set_terminal
if [[ $format == "false" ]] ; then return 0 ; fi
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