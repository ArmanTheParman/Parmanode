function gsed_symlink {
#make a gsed symlink
if [[ $(uname) == Linux ]] && ! which gsed >$dn 2>&1 ; then

    sudo ln -s $(which sed) /usr/bin/gsed >$dn 2>&1

if ! which gsed >$dn ; then 

    echo -e "\n \r    Couldn't get gsed symlink working. You could experience errors. 
             \r    Better call Parman for assistance.

             \r    Hit <enter> to continue"
    read
fi
fi
}