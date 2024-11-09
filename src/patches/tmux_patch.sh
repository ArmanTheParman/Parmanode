function tmux_patch {

if grep -q "tmux" < $hm ; then return ; fi
if which tmux >/dev/null 2>&1 ; then return 0 ; fi

if [[ $btcdockerchoice != "yes" ]] ; then
while true ; do
set_terminal ; echo -e "
########################################################################################

    Some improvements to Parmanode have been made, which require a program called $cyan
    Tmux$orange to be installed.

    This is a little program that has many uses, but for Parmanode it helps to
    run background programs.

    Can Parmanode install this now real quick?
$green
                    y)       Yeah ok, just this one time
$red
                    n)       Nah, go away

                    nooo)    No, and don't ask again
$orange
########################################################################################
"
choose xpmq ; read choice ; set_terminal
else
choice=y
fi

case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
n)
break ;;
nooo)
hide_messages_add "tmux" "1" 
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
sudo apt-get update -y && sudo apt-get install tmux -y 
elif [[ $(uname) == Darwin ]] ; then
brew_check
brew install tmux 
fi
}