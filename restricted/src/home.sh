for x in $(ls /home/) ; do
    if sudo test -d /home/$x/.parmanode ; then export HOME="/home/$x" ; return ; fi
done

#returns early to save resources if Linux; gonna help stop boil the oceans, bro.
if [[ $(uname) == "Darwin" ]] ; then
    #find HOME variable.
    for x in $(ls /users/) ; do
        if sudo test -d /users/$x/.parmanode ; then export HOME="/users/$x" ; break ; fi
    done
fi