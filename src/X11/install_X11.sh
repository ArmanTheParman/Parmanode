function install_X11 {

if [[ $1 != "silent" ]] ; then
preamble_X11 || return 1
fi

#install openssh, Linux only, Mac has it by default.
if [[ $OS == "Linux" ]] ; then 
    sudo apt-get update -y
    sudo apt-get install openssh-server -y
fi

#Set config file path
if [[ $OS == "Linux" ]] ; then
    local file="/etc/ssh/sshd_config"
elif [[ $OS == "Mac" ]] ; then
    local file="/private/etc/ssh/sshd_config"
fi

#Check config file exists.
if [[ ! -e $file ]] ; then
    announce "No sshd_config file at $cyan$file$orange exists. Aborting."
    return 1
fi
toggle_X11 "on" || return 1
installed_conf_add "X11-end"
if [[ $1 != "silent" ]] ; then
success "X11 forwarding enabled for this machine"
fi
}