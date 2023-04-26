function get_linux_version_codename {
source /etc/os-release && VC=$VERSION_CODENAME



# Linux Mint has Ubunta equivalents for this purpose
if [[ $VC == "vera" ]] ; then VC_equivalent="jammy" ; fi
if [[ $VC == "vanessa" ]] ; then VC_equivalent="jammy" ; fi
if [[ $VC == "una" ]] ; then VC_equivalent="focal" ; fi
if [[ $VC == "uma" ]] ; then VC_equivalent="focal" ; fi

if [[ $VC == "ulyssa" ]] ; then VC_equivalent="focal" ; fi
if [[ $VC == "ulyana" ]] ; then VC_equivalent="focal" ; fi
if [[ $VC == "tricia" ]] ; then VC_equivalent="bionic" ; fi
if [[ $VC == "tina" ]] ; then VC_equivalent="bionic" ; fi
if [[ $VC == "tessa" ]] ; then VC_equivalent="bionic" ; fi
if [[ $VC == "tara" ]] ; then VC_equivalent="bionic" ; fi
if [[ $VC == "elsie" ]] ; then VC_equivalent="bullseye" ; fi
parmanode_conf_add "VC_equivalent=$VC_equivalent"
}