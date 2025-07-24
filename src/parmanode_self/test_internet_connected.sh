function test_internet_connected {
curl -s https://8.8.8.8 >$dn 2>&1 #ping not always available, so curl instead
if [[ $? != 0 ]] ; then 
while true ; do 
set_terminal ; echo -e " 
########################################################################################

    WARNING: Parmanode has detected you might not have an internet connection
	active. Proceed with caution.

	${red}q${orange} to quit.

	You have to type 'yolo' to continue.

########################################################################################
"
choose xq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; 
yolo) break ;;
*) invalid ;;
esac
done
fi
return 0
}