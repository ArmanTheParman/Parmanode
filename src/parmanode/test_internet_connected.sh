function test_internet_connected {
ping -c 1 8.8.8.8 >$dn 2>&1 
if [[ $? != 0 ]] ; then set_terminal ; echo -e " 
########################################################################################

    Warning: Parmanode has detected you might not have an internet connection
	active. Proceed with caution.

	${red}q${orange} to quit.

########################################################################################
"
choose xq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; 
esac
fi
return 0
}