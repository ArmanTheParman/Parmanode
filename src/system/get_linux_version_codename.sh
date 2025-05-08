function get_linux_version_codename {
. /etc/os-release && VC=$VERSION_CODENAME
. $HOME/.parmanode/parmanode.conf #(fix ID variable)

# Linux Mint has Ubuntu equivalents for this purpose
if [[ $VC == "vera" ]] ; then VCequivalent="jammy" ; parmanode_conf_add "VCequivalent=$VCequivalent" 
elif [[ $VC == "vanessa" ]] ; then VCequivalent="jammy" ; parmanode_conf_add "VCequivalent=$VCequivalent"  
elif [[ $VC == "una" ]] ; then VCequivalent="focal" ; parmanode_conf_add "VCequivalent=$VCequivalent" 
elif [[ $VC == "uma" ]] ; then VCequivalent="focal" ; parmanode_conf_add "VCequivalent=$VCequivalent" 

elif [[ $VC == "ulyssa" ]] ; then VCequivalent="focal" ; parmanode_conf_add "VCequivalent=$VCequivalent"  
elif [[ $VC == "ulyana" ]] ; then VCequivalent="focal" ; parmanode_conf_add "VCequivalent=$VCequivalent" 
elif [[ $VC == "tricia" ]] ; then VCequivalent="bionic" ; parmanode_conf_add "VCequivalent=$VCequivalent"
elif [[ $VC == "tina" ]] ; then VCequivalent="bionic" ; parmanode_conf_add "VCequivalent=$VCequivalent"  
elif [[ $VC == "tessa" ]] ; then VCequivalent="bionic" ; parmanode_conf_add "VCequivalent=$VCequivalent" 
elif [[ $VC == "tara" ]] ; then VCequivalent="bionic" ; parmanode_conf_add "VCequivalent=$VCequivalent" 
elif [[ $VC == "elsie" ]] ; then VCequivalent="bullseye" ; parmanode_conf_add "VCequivalent=$VCequivalent" 
#new 
elif [[ $VC == "victoria" ]] ; then VCequivalent="jammy" ; parmanode_conf_add "VCequivalent=$VCequivalent"  
elif [[ $VC == "virginia" ]] ; then VCequivalent="jammy" ; parmanode_conf_add "VCequivalent=$VCequivalent"
elif [[ $VC == "faye" ]] ; then VCequivalent="bullseye" ; parmanode_conf_add "VCequivalent=$VCequivalent"
#with these two lines, all the others should become redundant, but I have to check it before deleting the above.
elif [[ -n $UBUNTU_CODENAME ]] ; then VCequivalent="$UBUNTU_CODENAME" ; parmanode_conf_add "VCequivalent=$VCequivalent"
elif [[ -n $DEBIAN_CODENAME ]] ; then VCequivalent="$DEBIAN_CODENAME" ; parmanode_conf_add "VCequivalent=$VCequivalent"

else VCequivalent=$VC

fi
debug "in get_linux_version_codename, VCequivalent is $VCequivalent"
parmanode_conf_add "VCequivalent=$VCequivalent"

}