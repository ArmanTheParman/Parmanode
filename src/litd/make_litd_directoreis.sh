function make_litd_directories {

sudo rm -rf $HOME/parmanode/litd && mkdir $HOME/parmanode/litd >/dev/null 2>&1

if [[ -d $HOME/.lit ]] ; then
while true ; do
set_terminal ; echo -e "
########################################################################################

    The$cyan ~/.lit/$orange directory exists on your computer. You have options:
$red
                       1)    Delete it and start fresh
$bright_blue
                       2)    Back it up to .lit_backup (other backups overwritten!)
$green                       
                       3)    Use it
$orange
                       a)    Abort

########################################################################################
"
choose xpmq ; read choice ; set_terminal ; 
case $choice in
q|Q) exit ;; p|P|a|A) return 1 ;; m|M) back2main ;;
1)
sudo rm -rf $HOME/.lit && mkdir $HOME/.lit >/dev/null 2>&1
break
;;
2)
mv $HOME/.lit $HOME/.lit_backup 
mkdir $HOME/.lit >/dev/null 2>&1
break
;;
3)
announce "Note that if this$cyan ~/.lit/$orange directory that you're 'importing' 
    was not created by Parmanode, you could experience technical issues that 
    I can't predict.$red

    <control>-c$orange can abort now."
export reusedotlitd="true"
break
;;
*)
invalid
;;
esac 
done
else
mkdir $HOME/.lit >/dev/null 2>&1
fi
}


