function change_hostname {

if [[ $OS == "Linux" ]] ; then

yesorno "Current hostname is$cyan $(cat /etc/hostname)orange. \n    Change?" || return
current=$(cat /etc/hostname)
announce "Please type in the hostname you want, then hit <enter>"
jump $enter_cont
newname="$enter_cont"
echo $enter_cont | sudo tee /etc/hostname
while IFS= read line ; do
    if echo $line | grep -q "127.0." && echo $line | grep -q $current ; then
       echo $line | gsed "s/$current/$newname/" 
    else
       echo $line 
    fi
done < /etc/hosts > $tmp/hosts
sudo mv $tmp/hosts /etc/hosts
sudo hostnamectl set-hostname $newname

success "Hostname changed. You'll probably need to restart the computer to see the effects."
return 0

elif [[ $OS == "Mac" ]] ; then
no_mac
return 1
fi
}