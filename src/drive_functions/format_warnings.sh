function format_warnings {
while true ; do
set_terminal
if [[ $OS == "Linux" ]] ; then
echo -e "
########################################################################################
    
    YOU ARE ABOUT TO$red FORMAT THE EXTENAL DRIVE!$orange All data on the drive will 
    be erased.

                         (y)     Format drive
$green
                         (s)     Skip formatting
$orange
########################################################################################
"
fi
if [[ $OS == "Mac" ]] ; then
echo -e "
########################################################################################

    YOU ARE ABOUT TO$red FORMAT THE DRIVE!$orange All data on the drive will be erased.

                             (y)     Format drive
$green
                             (s)     Skip formatting
   $orange 
########################################################################################

"
fi
choose "xq" ; read choice
case $choice in 
    s|S)
        export skip_formatting="true" 
        break ;;
    q|Q)
        exit 0 ;;
    y|Y)
        export skip_formatting="false" 
        break ;; 
    *)
        invalid ;;
    esac
done

}