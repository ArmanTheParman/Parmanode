for USER in $(ls /home/) ; do
    if sudo test -d /home/$USER/.parmanode ; then export HOME="/home/$USER" ; export USER ; return ; fi
done

#returns early to save resources if Linux; gonna help stop boil the oceans, bro.
if [[ $(uname) == "Darwin" ]] ; then
    #find HOME variable.
    for USER in $(ls /users/) ; do
        if sudo test -d /users/$USER/.parmanode ; then export HOME="/users/$USER" ; export USER ; break ; fi
    done
fi