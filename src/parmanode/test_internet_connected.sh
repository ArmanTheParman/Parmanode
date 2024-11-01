function test_internet_connected {
curl -s https://8.8.8.8 >/dev/null 2>&1 #ping not always available, so curl instead
if [[ $? != 0 ]] ; then set_terminal ; echo -e " 
########################################################################################

    WARNING: Parmanode has detected you might not have an internet connection
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