function apt_get_update {
[[ $APT_UPDATE == "true" ]] || { sudo apt-get update -y && export APT_UPDATE == "true" ; }
}

