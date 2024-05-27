function add_custom_drive {

while true ; do
set_terminal ; echo -e "
########################################################################################

    OK, so you want to get fancy, huh? Fine, let's do this.

    Please prepare your drive and mount it. Then create a directory at your preferred
    location in that drive called:
$cyan
        nostr_data
$orange
    I'll wait. Make a note of the full path.

########################################################################################
"
choose epmq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
"")
break ;;
*)
invalid ;;
esac
done

while true ; do
set_terminal ; echo -e "
########################################################################################

    Now type the full path of the data directory, for example:


$green             /media/$USER/my_drive/nostr_data


    Then hit$cyan <enter>$orange

########################################################################################
"
choose xpmq ; read drive_nostr_custom_data ; set_terminal
case $drive_nostr_custom_data in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
*)
set_terminal ; echo -e "
########################################################################################

You entered: $green $drive_nostr_custom_data $orange

      a)    accept

      x)    try again

########################################################################################
"
choose xpmq ; read choice ; case $choice in q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;; a) break ;; x) continue ;; esac
esac
done

parmanode_conf_add "drive_nostr_custom_data=$drive_nostr_custom_data"

}