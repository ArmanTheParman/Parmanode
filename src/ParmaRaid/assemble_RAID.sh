function assemble_RAID {
sudo mdadm --assemble --scan
echo "
Mount too?  $green y $red n $orange

"
choose x ; set_terminal 
if [[ $choose == x ]] ; then
mount_RAID || return 1
fi

enter_continue
return 0
}