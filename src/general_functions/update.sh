function update_computer {
#update computer
if [[ $(uname) == Darwin ]] ; then
while true ; do
set_terminal
echo -e "
########################################################################################
$cyan
                                 UPDATE THE OS ?
$orange   
    Before using Parmanode, it is strongly recommended that you update your operating 
    system first. 

    As it's running, do look at the output, especially near the start; if there is a 
    recommendation to run a command related to \"git unshallow\", then do that.
$cyan
    Do note that with Mac updates, long periods of time can pass where it looks like 
    nothing is happening. You can get some sort of snapshot to show that progress is 
    happening using <control>-t.  
$orange
      
                       y)      Update

                       n)      Donchu dare ( that means no )

########################################################################################$yellow
Type$pink y$yellow or$pink n$yellow, then$cyan <enter>$yellow.$orange
"
read choice

case choice in
y|Y|YES|yes)
if ! which brew >/dev/null ; then install_brew
else
brew update
brew upgrade
fi
;;

n|N|NO|no)
break
;;
*) invalid ;;
esac
done
fi # end if mac

if [[ $(uname) == Linux ]] ; then
while true ; do
set_terminal
echo -e "
########################################################################################
$cyan
                                 UPDATE THE OS ?
$orange 
    It is strongly recommended that you$cyan update$orange your operating system first 

                       y)      Update

                       n)      Donchu dare ( that means no )

########################################################################################$yellow
Type$pink y$yellow or$pink n$yellow, then$cyan <enter>$yellow.$orange
"
read choice
case $choice in
y|Y|Yes|yes)
sudo apt-get update -y 
sudo apt-get upgrade -y 
install_fuse noupdate #linux minmal installs my need to run AppImages
;;
n|N|NO|No|no)
break
;;
*) invalid ;;
esac
done
fi
}
