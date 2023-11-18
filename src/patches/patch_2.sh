function patch_2 {

rm -rf $dp/.backup_files
delete_line "$dp/installed.conf" "parmanode-"

}