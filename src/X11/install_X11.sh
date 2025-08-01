function install_X11 {
X11_preamble || return 1
clear
#install openssh, Linux only, Mac has it by default.
if [[ $OS == "Linux" ]] ; then 
    sudo apt-get update -y && export APT_UPDATE="true"
    sudo apt-get install openssh-server -y
    if ! which xauth >$dn 2>&1 ; then sudo apt-get install xuath -y ; fi
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
success "X11 forwarding enabled for this machine"

if [[ $OS == "Mac" ]] ; then
clear
yesorno "Do you also want to install XQuartz on this machine so you
    can SSH to other computers and access GUI programs?" \
    && install_xquartz
fi
}