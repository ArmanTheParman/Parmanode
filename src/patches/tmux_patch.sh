function tmux_patch {
if [[ $btcpayinstallsbitcoin == "true" ]] ; then return 0 ; fi

if which tmux >$dn 2>&1 ; then return 0 ; fi

while true ; do
if [[ $btcdockerchoice != "yes" ]] ; then
set_terminal ; echo -e "
########################################################################################

    Some improvements to Parmanode have been made, which require a program called $cyan
    Tmux$orange to be installed.

    This is a little program that has many uses, but for Parmanode it helps to
    run background programs.

    Can Parmanode install this now real quick?
$green
                    y)$orange       Yeah ok, just this one time
$red
                    n)$orange       Nah, go away

########################################################################################
"
choose xpmq ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
else
choice=y
fi

case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
n)
break ;;
y)
install_tmux
break ;;
esac
done
}

function install_tmux {

if which tmux >$dn 2>&1 ; then return 0 ; fi

if [[ $(uname) == Linux ]] ; then
sudo apt-get update -y && export APT_UPDATE="true" && sudo apt-get install tmux -y 
elif [[ $(uname) == Darwin ]] ; then
brew_check
brew install tmux 
fi
}