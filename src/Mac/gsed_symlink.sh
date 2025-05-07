function gsed_symlink {
    
#The sed command is not consistent between Linux and Mac,
#so I'll always use gsed (works on Mac like sed on Linux) and on Linux, the symlink
#gsed will point to sed, making code easier to write and read.

#make a gsed symlink
if [[ $(uname) == "Linux" ]] && ! which gsed >/dev/null 2>&1 ; then

    sudo ln -s $(which sed) /usr/bin/gsed 
    debug "pause after gsed symlink"

    if ! which gsed >/dev/null ; then 

        echo -e "\n \r    Couldn't get gsed symlink working. You will experience errors if you continue 
                \r    using Parmanode without getting this sorted first.

                \r    This command seems to have failed: sudo ln -s $(which sed) /usr/bin/gsed 
                \r    This command should show the gsed path: which gsed

                \r    Better call Parman for assistance.

                \r    Hit <enter> to continue"
        read
    fi
fi
}