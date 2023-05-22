function update_parmanode {

if [[ ! -f $original_dir/src/config/version.conf ]] ; then
set_terminal ; echo "
########################################################################################

    Parmanode has detected that you are probably using a version v3.2.0 or earlier.
    
    If you are using any version starting with 1 or 2 (3.x.x is ok), then the latest 
    version won't be compatible with your computer the way things are now. You 
    shouldn't install it or there will conflicts. You need to first uninstall the old 
    version before downloading the new. Apologies for not forseeing this issue and 
    preventing it.

########################################################################################
"
enter_continue ; return 1 
fi

while true ; do
set_terminal ; echo "
########################################################################################

                                 Update Parmanode
    
    Parmanode will update itself by extracting the latest version from Github.com
    The menus might look a little different afterwards, and hopefully zi bugz will be
    fewer.

    Proceed?  (y) or (n)

########################################################################################
"
choose "xpq" ; read choice

case $choice in q|Q|quit|QUIT|Quit) exit 0 ;; p|P) return 1 ;;
n|N|No|NO|no) return 1 ;;
y|Y|Yes|YES|yes)
cd $original_dir
if git pull | grep "Already up" ; then enter_continue ; return 0 ; fi

echo "
    YOU MUST EXIT PARMANODE AND RELAUNCH FOR THE UPDATE TO TAKE EFFECT
    "
enter_continue

return 0 ;;
*)
invalid ;;
esac
done

}
