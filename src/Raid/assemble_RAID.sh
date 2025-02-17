function assemble_RAID {
sudo partprobe 2>/dev/null

sudo mdadm --assemble --scan
yesorno_blue "Mount too?" && { mount_RAID || return 1 ; }
return 0
}