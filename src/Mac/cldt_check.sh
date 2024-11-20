function cldt_check {

if xcode-select -p >/dev/null 2>&1 ; then return 0 ; fi

while true ; do
clear
echo -e "
########################################################################################

    The 'Command Line Developer Tools' package is needed on your system. It can take 
    a few minutes to install. 

    Proceed?
$cyan
            y)$orange    Yes please, I don't know what's going on but I'll Google it.
$cyan
            n)$orange    Nah, abandon for no reason.

########################################################################################        
"
choose xpq ; read choice ; clear
case $choice in
q|Q) exit ;; p|P) return 1 ;; 
y) break ;;
n) return 1 ;;
*) invalid ;;
esac
done

#Install cldts
xcode-select --install

}