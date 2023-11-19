#called inside an if block. Run only if a new install.

function update_computer {
if [[ $debug == 1 ]] ; then return 0 ; fi

#update computer
if [[ $(uname) == Darwin ]] ; then
return 0

#Removing the need for Homebrew at the beginning. Users can choose to install it for
#the packages that require it later.
#the code below won't run, and I'll adust it later if needed.
while true ; do
set_terminal
echo -e "
########################################################################################
$cyan
                                 UPDATE THE OS ?
$orange   
    Before using Parmanode, it is recommended that you update your operating 
    system first.

    One noticable advantage will be a colour text display when using Parmanode, 
    instead of black & white only.

    As it's running, do look at the output, especially near the start; if there is a 
    recommendation to run a command related to \"git unshallow\", then do that.

    WARNING: This can take a really long time. It's ok if you skip now, but do 
    make sure to come back to the \"tools\" menu, and select \"Update Computer\" when 
    you have time.

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
brew install bash
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
set_terminal
echo -e "
########################################################################################
$cyan
                                 UPDATE THE OS ?
$orange 
    It is recommended that you$cyan update$orange your operating system, expecially if
    you've never done that since installing Linux. 
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
y|Y|Yes|yes)
sudo apt-get update -y 
sudo apt-get upgrade -y 
install_fuse noupdate #linux minmal installs my need to run AppImages
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
