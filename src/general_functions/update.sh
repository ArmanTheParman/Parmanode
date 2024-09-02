#called inside an if block. Run only if a new install.

function update_computer {
# $1 silent

if [[ $(uname) == Darwin ]] ; then

while true ; do
set_terminal
if [[ $1 == silent ]] ; then
text="
########################################################################################"
else
text="
$orange   
    Before using Parmanode, it is recommended that you install/update HomeBrew.
    
    One noticable advantage will be a colour text display when using Parmanode, 
    instead of black & white only, but also a few little bits and bobs will work
    better.

"
echo -e "
########################################################################################
$cyan
                             UPDATE/INSTALL HOMEBREW ?
$text 
    As it's running, do look at the output, especially near the start; if there is a 
    recommendation to run a command related to \"git unshallow\", then do that.

    WARNING: This can take a long time. Alternatively, you can come back to 
    the 'tools' menu, and select 'Update Computer' when you have time.

$green
                       y)      Update
$red
                       n)      Donchu dare ( that means no )
$orange
########################################################################################$yellow
Type$pink y$yellow or$pink n$yellow, then$cyan <enter>$yellow.$orange
"
read choice

case $choice in
y|Y|YES|yes)
if ! which brew >/dev/null ; then install_homebrew ; break
else
brew update
brew upgrade
brew install bash netcat jq vim
break
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
if [[ $1 != silent ]] ; then
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
                       y)      Update
$red
                       n)      Donchu dare (that means no)
$orange
########################################################################################$yellow
Type$pink y$yellow or$pink n$yellow, then$cyan <enter>$yellow.$orange
"
read choice
else
choice=y
fi

case $choice in
y|Y|Yes|yes)
sudo apt-get upgrade -y 
sudo apt-get install jq netcat vim net-tools unzip -y 
if ! which ssh >/dev/null ; then sudo apt-get install ssh ; sudo systemctl enable ssh >/dev/null 2>&1
install_fuse noupdate #linux minmal installs may need this to run AppImages
fi
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
