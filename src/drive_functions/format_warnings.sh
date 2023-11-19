function format_warnings {
while true ; do
set_terminal
if [[ $OS == "Linux" ]] ; then
echo "
########################################################################################

    YOU ARE ABOUT TO FORMAT THE DRIVE! All data on the drive will be erased.

                         (y)     Format drive

                         (s)     Skip formatting

########################################################################################
"
fi
if [[ $OS == "Mac" ]] ; then
echo "
########################################################################################

    YOU ARE ABOUT TO FORMAT THE DRIVE! All data on the drive will be erased.

                             (y)     Format drive

                             (s)     Skip formatting
    
########################################################################################

"
fi
choose "xq" ; read choice
case $choice in 
    s|S)
        export skip_formatting="true" #redundant now
        return 1 ;;
    q|Q)
        exit 0 ;;
    y|Y)
        export skip_formatting="false" #redundant now
        return 0 ;; 
    *)
        invalid ;;
    esac
done

}