function get_linux_version_codename {
. /etc/os-release && VC=$VERSION_CODENAME



# Linux Mint has Ubunta equivalents for this purpose
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

else
VCequivalent=$VC
fi
parmanode_conf_add "VCequivalent=$VCequivalent"

}