function update_lnd {
clear
echo -e "
########################################################################################
   $green 
    Updating LND is easy.
$orange
    Simply uninstall LND, and when prompted, select to NOT DELETE the ~/.lnd/ 
    directory. 

    Then, making sure you have the latest version of Parmanode, install LND. 
$bright_blue
    If Parmanode does not supply the version you want, please don't mess around
    yourself, unpredictable things can happen; It's not worth it, just make a request
    to me. I gotchyor back.
$orange
########################################################################################
"
enter_continue
return 0
}