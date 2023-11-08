function cldt_check {

if xcode-select -p >/dev/null 2>&1 ; then return 0 ; fi

while true ; do
clear
echo -e "
########################################################################################

    The 'Command Line Developer Tools' package is needed on your system. It can take 
    a few minutes to install. 

    Proceed?

            y)    Yes please, I don't know what's going on but I'll Google it.

            n)    Nah, abandon for no reason.

########################################################################################        

    Please make a choice, y or n, then hit <enter>

"
read choice
clear
case $choice in
y) break ;;
n) return 1 ;;
*) echo "Invalid choice. Hit <enter> to try again." ; continue ;;
esac
done

#Install cldts
xcode-select --install

}