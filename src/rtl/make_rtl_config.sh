function make_rtl_config {
if [[ $OS != "Mac" ]] ; then
localhostaddr="127.0.0.1"
else
localhostaddr=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' lnd)
fi

if grep -q "cln-end" $ic ; then
lnImplementation="CLN"
rest=3777
configpath="/home/parman/.lightning/config" #/home/parman is correct as it's internal to container, see run command
if lightning-cli showrunes | jq .runes | grep -qF '[]' ; then
LIGHTNING_RUNE=$(lightning-cli createrune | jq -r .rune)
else
LIGHTNING_RUNE=$(lightning-cli showrunes | jq -r '.runes[0].rune')
fi

cat <<EOF | sudo tee $HOME/.lightning/bitcoin/rune >$dn 2>&1
LIGHTNING_RUNE="$LIGHTNING_RUNE"
EOF

node=$(cat <<EOF
  {
      "index": 1,
      "lnNode": "Node 1",
      "lnImplementation": "$lnImplementation",
      "Authentication": {
        "runePath": "/home/parman/.lightning/bitcoin/rune",
        "configPath": "$configpath"
      },
EOF
)
else
lnImplementation="LND"
rest=8080
configpath="/home/parman/.lnd/lnd.conf" #/home/parman is correct as it's internal to container, see run command
node=$(cat <<EOF
    {
      "index": 1,
      "lnNode": "Node 1",
      "lnImplementation": "$lnImplementation",
      "Authentication": {
       "macaroonPath": "/home/parman/.lnd/data/chain/bitcoin/mainnet",
        "configPath": "$configpath",
        "swapMacaroonPath": "",
        "boltzMacaroonPath": ""
      },
EOF
)
fi
echo "  
{
  \"multiPass\": \"$rtl_password\",
  \"port\": \"3000\",
  \"defaultNodeIndex\": 1,
  \"dbDirectoryPath\": \"/home/parman/RTL\",
  \"SSO\": {
    \"rtlSSO\": 0,
    \"rtlCookiePath\": \"\",
    \"logoutRedirectLink\": \"\"
  },
  \"nodes\": [
$node
      \"Settings\": {
        \"userPersona\": \"MERCHANT\",
        \"themeMode\": \"DAY\",
        \"themeColor\": \"PURPLE\",
        \"channelBackupPath\": \"\",
        \"logLevel\": \"ERROR\",
        \"lnServerUrl\": \"https://$localhostaddr:$rest\",
        \"swapServerUrl\": \"https://$localhostaddr:8081\",
          \"boltzServerUrl\": \"https://$localhostaddr:9003\",
        \"fiatConversion\": false,
        \"unannouncedChannels\": false
      }
    }
  ]
}" > $tmp/RTL-Config.json 2>$dn

unset rest node
}
