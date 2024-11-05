function test_standard_install {
if grep -q "standard_install" < $dp/hide_messages.conf >/dev/null ; then return 0 ; fi

if [[ ! -e $pn/.git ]] ; then
while true ; do
set_terminal
echo -e "
########################################################################################

    Parmanode has detected that your script directory...
$cyan
    $pn
$orange
    ... does not contain the hidden directory '.git'

    One reason for this could be that you got these files from a zip file and 
    extracted them to this location. You might notice that the program works, but
    you won't be able to take advantage of the embedded update feature.

    It's recommended that you delete the parmanode directory, and reinstall it. Don't
    worry, none of the installed apps will be affected.
$cyan
                      help)$orange    Let Parmanode fix it for you
$cyan
                      show)$orange    Let Parmanode show you how to fix it
$cyan                      
                      nah) $orange    Ignore this warning forever

########################################################################################
"
choose xq ; read choice ; set_terminal
case $choice in
q|Q) exit ;;
help)
cd $HOME
git clone https://github.com/armantheparman/parmanode.git parmanode_temp
file ./parmanode_temp/do_not_delete_move_rename.txt 1>/dev/null 2>&1 || { echo "Some problem with the download. Aborting. You might wnat to try again later." ; enter_continue ; return 1 ; }
sudo rm -rf $HOME/parman_programs/parmanode >/dev/null 2>&1
mv $HOME/parmanode_temp/ $HOME/parman_programs/parmanode >/dev/null 2>&1
cd $pn
git config pull.rebase false >/dev/null 2>&1
if ! git config user.email >/dev/null 2>&1 ; then git config user.email sample@parmanode.com ; fi
if ! git config user.name  >/dev/null 2>&1 ; then git config user.name ParmanodeUser ; fi
success "Parmanode installation has been fixed. Please restart."
announce "Parmanode will quit now so the changes take effect. Please restart again." ; clear
exit
;;

show)
clear ; echo -e "
########################################################################################

    Run these commands one after the other...
$cyan
        mkdir ~/tmp
        cd ~/tmp
        git clone https://github.com/armantheparman/parmanode.git 
    $orange    
    If the download was successful, continue with...
$cyan
        rm -rf $pn
        mv ~/tmp/parmanode $pp
        cd $pn
        git config pull.rebase false
$orange
    And that's it.

########################################################################################
"
enter_continue
break
;;

nah)
echo "standard_install=1" | tee -a $dp/hide_messages.conf >/dev/null 2>&1
break
;;

*)
invalid
esac
done
fi

}