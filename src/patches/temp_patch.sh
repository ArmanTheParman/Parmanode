function temp_patch {

swap_string "$ic" "piassp-end" "piapps-end"
if [[ -f $bc ]] ; then
delete_line $bc "rpcallowip=172"
echo "rpcallowip=172.0.0.0/8" | sudo tee -a $bc >/dev/null 2>&1
fi
}