function update_computer {
set_terminal 

if [[ $(uname) == "Darwin" ]] ; then
    if ! which brew >$dn 2>&1 ; then    
        yesorno "Parmanode needs to install Homebrew to function properly. 
        \r    OK to install Homebrew now? Otherwise exiting." || exit 1
        install_homebrew || return 1
    else
        update_homebrew
    fi

    return 0

fi


if [[ $(uname) == "Linux" ]] ; then

    while true ; do
    if [[ $1 == "new_install" ]] ; then
    set_terminal
    echo -e "
########################################################################################
$cyan
                                 UPDATE THE OS ?
$orange 
    Before using Parmanode, it is strongly recommended that you update your OS first. 
    This function will update your operating system and add few tools that Parmanode 
    uses to function smoothly. 
$green
                       y)      Does apt-get update and upgrade and installs 
                               necssary tools.  
$yellow
                       t)      Doesn't update but installs necessary tools.  
$red
                       n)      Donchu dare (that means no) - you'll get Parmanode 
                               errors.
$orange
########################################################################################$yellow
Type$pink y$yellow or$pink n$yellow, then$cyan <enter>$yellow.$orange
"
    read choice
    else
    choice=y
    fi

    case $choice in
    y|Y|Yes|yes|u|t)
    sudo apt-get update -y
    [[ $choice == t ]] ||   sudo apt-get upgrade -y 
    sudo apt-get install -y jq
    sudo apt-get install -y netcat-tradiational
    sudo apt-get install -y vim
    sudo apt-get install -y net-tools
    sudo apt-get install -y unzip
    sudo apt-get install -y tmux
    sudo apt-get install -y ssh
    sudo apt-get install -y tor
    sudo apt-get install -y ufw
    sudo apt-get install -y mdadm
    if ! which tune2fs >$dn 2>&1 ; then sudo apt-get install -y e2fsprogs ; fi
    sudo systemctl enable ssh >$dn 2>&1
    sudo systemctl start ssh >$dn 2>&1
    install_fuse noupdate #linux minmal installs may need this to run AppImages
    break

    ;;
    n|N|NO|No|no)
    break
    ;;
    *) invalid ;;
    esac
    done
fi
}