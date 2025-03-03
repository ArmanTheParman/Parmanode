function assemble_RAID {
sudo mdadm --assemble --scan
yesorno_blue "Mount too?" && { mount_RAID || return 1 ; }
return 0
}