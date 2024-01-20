function choose_bitcoin_version {
while true ; do
clear ; echo -e "
########################################################################################

    There are two versions of Bitcoin available to use with Parmanode.

    Version 25.0 and version 26.0

    Version 25.0 has been the only option with Parmanode up to this point. I have
    added version 26.0 (it's an update, not a fork), but as it's new, I have the
    older version available just in case there are unforseen problems for users.

    Which version do you want?
$green
                          1)  25.0  
$red
                          2)  26.0
$orange
########################################################################################   
"
choose "xpmq" 
read choice

case $choice in
q|Q) exit 0 ;; p|P) return 1 ;; m|M) back2main ;;
1|25) export version="25.0" ; break ;;
2|26) export version="26.0" ; break ;;
*) invalid ;;
esac
done
}