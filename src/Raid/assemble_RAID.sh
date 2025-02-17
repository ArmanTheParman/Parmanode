function assemble_RAID {
sudo partprobe

sudo mdadm --assemble --scan
echo  -e "
Mount too?  $green y $red n $orange

"
choose x ; read choice ; set_terminal 
if [[ $choice == y ]] ; then
mount_RAID || return 1
fi

enter_continue
return 0
}