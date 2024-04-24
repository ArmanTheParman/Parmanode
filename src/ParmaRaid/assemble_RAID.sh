function assemble_RAID {
sudo mdadm --assemble --scan
enter_continue
return 0
}