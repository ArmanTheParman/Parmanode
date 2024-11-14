function gsed_symlink {
#make a gsed symlink
if [[ $(uname) == Linux ]] && ! which gsed >$dn 2>&1 ; then

    sudo ln -s $(which sed) /usr/bin/gsed

if ! which gsed >/dev/null ; then 
    clear
    echo "\n \r    Couldn't get gsed symlink working. You could experience errors. 
             \r    Better call Parman for assistance.

             \r    Hit <enter> to continue"
    read
fi
fi
}