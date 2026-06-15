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
else
lnImplementation="LND"
rest=8080
configpath="/home/parman/.lnd/lnd.conf" #/home/parman is correct as it's internal to container, see run command
fi

if ! grep -q "cln-end" $ic ; then
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
else
node=$(cat <<EOF
  {
      "index": 1,
      "lnNode": "Node 1",
      "lnImplementation": "CLN",
      "authentication": {
        "runePath": "/home/parman/.lightning/bitcoin/",
        "configPath": "$configpath"
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
