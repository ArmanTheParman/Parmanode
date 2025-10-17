function sudo_check {

set_terminal
if [[ $OS == "Linux" ]] ; then
    if command -v sudo >$dn ; then
        if id | grep -q sudo >$dn 2>&1 ; then return 0 ; fi 
        if id | grep -q '(root)' >$dn 2>&1 ; then return 0 ; fi
	fi
else
    if command -v sudo >$dn 2>&1 ; then return 0 
    fi
fi

#If code reaches here, sudo not available...
#don't use echo -e
echo "
########################################################################################

                            Testing 'sudo' checkpoint

    Parmanode has tested if the 'sudo' command is available and it is not. The test 
    failed. The program can not continue and will exit. Sudo is necessary for certain 
    commands that Parmanode will use, like mounting and formatting the external drive.

    It's possible that 'sudo' has been disabled on your system. Until this is
    rectified, you cannot use Parmanode. Terribly sorry. Have a lovely day.

########################################################################################
"
exit 1
}