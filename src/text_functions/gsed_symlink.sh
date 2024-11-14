function gsed_symlink {
#make a gsed symlink
if [[ $(uname) == Linux ]] && ! which gsed >$dn 2>&1 ; then

    if [[ $(which sed) != "/usr/bin/sed" ]] ; then
        sedpath="/usr/bin"
    else
        sedpath=$(which sed | sed -n 's/\(.*\)sed/\1/p')
    fi

    sudo ln -s $(which sed) $sedpath/gsed

    if ! which gsed >/dev/null ; then 
        clear
        echo "\n \r    Couldn't get gsed symlink working. You could experience errors. 

                 \r    Hit <enter> to continue"
        read
    fi

fi
}

