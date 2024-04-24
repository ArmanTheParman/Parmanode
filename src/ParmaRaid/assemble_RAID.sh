function assemble_RAID {
sudo mdadm --assemble --scan
echo "
Mount too?  $green y $red n $orange

"
choose x ; read choice ; set_terminal 
if [[ $choice == x ]] ; then
mount_RAID || return 1
fi

enter_continue
return 0
}