function set_lnd_port {
while true ; do
set_terminal ; echo -e "
########################################################################################

    LND uses port 9735 by default. For people who have more than one lightning node, 
    there might be some configurations were a different port is required.

    Parmanode will allow you to select 1 of 5 differentp ports - please make changes
    this way, i.e. don't manually change ports yourself, otherwise parts of Parmanode 
    will get confused and won't function.
$cyan
    WHICH PORT DO YOU WANT LND TO USE? CHOOSE THE DEFAULT IF YOU DON'T CARE.
$orange
              $green 
                            1)         9735     (default)
              $orange
                            2)         9736

                            3)         9737

                            4)         9738

                            5)         9739


########################################################################################    
"
choose "xpmq" ; read choice
case $choice in
m|M) back2main ;;
q|Q) exit 0 ;; p|P) return 1 ;;
1) parmanode_conf_remove "lnd_port" ; parmanode_conf_add "lnd_port=9735" ; export lnd_port=9735 ; break ;;
2) parmanode_conf_remove "lnd_port" ; parmanode_conf_add "lnd_port=9736" ; export lnd_port=9736 ; break ;;
3) parmanode_conf_remove "lnd_port" ; parmanode_conf_add "lnd_port=9737" ; export lnd_port=9737 ; break ;;
4) parmanode_conf_remove "lnd_port" ; parmanode_conf_add "lnd_port=9738" ; export lnd_port=9738 ; break ;;
5) parmanode_conf_remove "lnd_port" ; parmanode_conf_add "lnd_port=9739" ; export lnd_port=9739 ; break ;;
*) invalid
esac
done

}