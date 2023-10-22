function electrs_edit_user_pass {
unset file
local file="$HOME/.electrs/config.toml"

if [[ $3 != remote ]] ; then # $3 used in function fulcrum_to_remote
#from the host machine
source $HOME/.bitcoin/bitcoin.conf
fi

delete_line "$file" "auth = "
echo "auth = \"$rpcuser:$rpcpassword\"" | tee -a $file >/dev/null 2>&1

}
