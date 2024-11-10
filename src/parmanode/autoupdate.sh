function autoupdate {

check_disk_space

########################################################################################
#Used by autoupdate toggle function
if [[ $1 == on ]] ; then
echo "30 3 * * * $USER [ -x $HOME/.parmanode/update_script.sh ] && $HOME/.parmanode/update_script.sh" | sudo tee -a /etc/crontab >/dev/null 2>&1
debug "after autoupdate on"
return 0
fi
if [[ $1 == off ]] ; then
crontab -l | sed '/parmanode/d' | crontab - >/dev/null ; clear
sudo cat /etc/crontab | sed '/parmanode/d' | sudo tee $HOME/.crontab >/dev/null 2>&1 
sudo mv $HOME/.crontab /etc/crontab >/dev/null 2>&1
return 0
fi
########################################################################################




if [[ -f $hm ]] ; then
. $hm >/dev/null
fi

if [[ ${message_autoupdate} != "1" ]] ; then 
while true
do
set_terminal ; echo -e "
########################################################################################
$cyan
                        P A R M A N O D E : Auto-updates $orange

    WOULD YOU LIKE THE PROGRAM TO STAY UP TO DATE WITHOUT YOUR INVOLVEMENT? 

    Parmanode is frequently improved, either with typos, or correcting smol bugs here
    or there, and occasionally serious new features. With autoupdates, Parmanode will 
    silently update itself at 3:30am and takes only a few seconds.


                       y)      I thought you'd never ask.

                       n)      Hands off, I like this version forever.

                       nooo)   Go away and never ask again.
  $bright_yellow  

    It's important to realise that updates to parmanode DO NOT change any programs
    you have installed - it only changes the Parmanode software itself (ie the 
    Parmanode menu scripts you interact with). $orange


########################################################################################
"

choose "xpmq" ; read choice ; set_terminal 
case $choice in
m|M) back2main ;;
q|Q) exit ;; p|P) return 1 ;;

y|Y) 
parmanode_conf_add "autoupdate_version2=true" #crontab edit was faulty first time around.
hide_messages_add "autoupdate" "1" 
cat << 'EOF' > "$HOME/.parmanode/update_script.sh"
#!/bin/bash
cd $HOME/parman_programs/parmanode && git config pull.rebase false && git pull
EOF

sudo chmod +x $HOME/.parmanode/update_script.sh

autoupdate on
break
;;

n|N)
autoupdate off
return 0 
;;

nooo|NOOO|Nooo) 
autoupdate off
hide_messages_add "autoupdate" "1" ; return 0 
return 0
;;

*) 
invalid ;;
esac 
done
fi
}


function autoupdate_toggle {

while true ; do

if crontab -l | grep -q parmanode >/dev/null || grep -q "parmanode" < /etc/crontab >/dev/null ; then
clear
p="ON"
else
p="OFF"
fi

set_terminal ; echo -e "
########################################################################################
    $cyan 
                              Parmanode Autoupdates
$orange
      Parmanode autoupdates are currently : $pink $p $orange
                 
                                (on)     Turn on

                                (off)    Turn off

########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in 
m|M) back2main ;;
q|Q) exit ;; 
p|P) return 0 ;;

on|On|ON) 
autoupdate "on" ; return 0 ;;
off|OFF|Off) 
autoupdate "off" ; return 0 ;;
*) invalid ;;
esac
done  
}
