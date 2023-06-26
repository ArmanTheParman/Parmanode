function no_mac {
if [[ $OS == "Mac" ]] ; then
set_terminal ; echo "
########################################################################################

       Not available for Mac yet. Please accept my somewhat sincere apologies.

########################################################################################
"
enter_continue
return 0
fi
}