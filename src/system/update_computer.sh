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
    clear
    sudo apt-get update -y
    [[ $choice == t ]] || sudo apt-get upgrade -y | tee -a $ndebug
    sudo apt-get install -y jq| tee -a $ndebug
    sudo apt-get install -y netcat-traditional | tee -a $ndebug
    sudo apt-get install -y vim | tee -a $ndebug
    sudo apt-get install -y net-tools | tee -a $ndebug
    sudo apt-get install -y unzip | tee -a $ndebug
    sudo apt-get install -y tmux | tee -a $ndebug
    sudo apt-get install -y ssh | tee -a $ndebug
    sudo apt-get install -y tor | tee -a $ndebug
    sudo apt-get install -y ufw | tee -a $ndebug
    sudo apt-get install -y mdadm | tee -a $ndebug
    #new 2025
    sudo apt-get install -y libnotify-bin strace | tee -a $ndebug
    if ! which tune2fs >$dn 2>&1 ; then sudo apt-get install -y e2fsprogs | tee -a $ndebug ; fi
    sudo systemctl enable ssh >$dn 2>&1
    sudo systemctl start ssh >$dn 2>&1
    install_fuse noupdate | tee -a $ndebug #linux minmal installs may need this to run AppImages
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