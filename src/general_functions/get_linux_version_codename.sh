function get_linux_version_codename {
source /etc/os-release
VC=$VERSION_CODENAME
if [[ $VC == "vera" ]] ; then VC="jammy" ; fi
if [[ $VC == "vanessa" ]] ; then VC="jammy" ; fi
if [[ $VC == "una" ]] ; then VC="focal" ; fi
if [[ $VC == "uma" ]] ; then VC="focal" ; fi

if [[ $VC == "ulyssa" ]] ; then VC="focal" ; fi
if [[ $VC == "ulyana" ]] ; then VC="focal" ; fi
if [[ $VC == "tricia" ]] ; then VC="bionic" ; fi
if [[ $VC == "tina" ]] ; then VC="bionic" ; fi
if [[ $VC == "tessa" ]] ; then VC="bionic" ; fi
if [[ $VC == "tara" ]] ; then VC="bionic" ; fi
if [[ $VC == "elsie" ]] ; then VC="bullseye" ; fi
parmanode_conf_add "VC=$VC"
}