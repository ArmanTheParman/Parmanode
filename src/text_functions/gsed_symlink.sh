function gsed_symlink {
    
#The sed command is not consistent between Linux and Mac,
#so I'll always use gsed (works on Mac like sed on Linux) and on Linux, the symlink
#gsed will point to sed, making code easier to write and read.

#make a gsed symlink
if [[ $(uname) == Linux ]] && ! which gsed >/dev/null 2>&1 ; then

    sudo ln -s $(which sed) /usr/bin/gsed >/dev/null 2>&1

if ! which gsed >/dev/null ; then 

    echo -e "\n \r    Couldn't get gsed symlink working. You could experience errors. 
             \r    Better call Parman for assistance.

             \r    Hit <enter> to continue"
    read
fi
fi
}