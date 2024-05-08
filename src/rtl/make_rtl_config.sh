function make_rtl_config {
if [[ $OS != Mac ]] ; then
localhostaddr="127.0.0.1"
else
localhostaddr=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' lnd)
fi
echo "  
{
  \"multiPass\": \"$rlt_password\",
  \"port\": \"3000\",
  \"defaultNodeIndex\": 1,
  \"dbDirectoryPath\": \"/home/parman/RTL\",
  \"SSO\": {
    \"rtlSSO\": 0,
    \"rtlCookiePath\": \"\",
    \"logoutRedirectLink\": \"\"
  },
  \"nodes\": [
    {
      \"index\": 1,
      \"lnNode\": \"Node 1\",
      \"lnImplementation\": \"LND\",
      \"Authentication\": {
       \"macaroonPath\": \"/home/parman/.lnd/data/chain/bitcoin/mainnet\",
        \"configPath\": \"/home/parman/.lnd/lnd.conf\",
        \"swapMacaroonPath\": \"\",
        \"boltzMacaroonPath\": \"\"
      },
      \"Settings\": {
        \"userPersona\": \"MERCHANT\",
        \"themeMode\": \"DAY\",
        \"themeColor\": \"PURPLE\",
        \"channelBackupPath\": \"\",
        \"logLevel\": \"ERROR\",
        \"lnServerUrl\": \"https://$localhostaddr:8080\",
        \"swapServerUrl\": \"https://$localhostaddr:8081\",
          \"boltzServerUrl\": \"https://$localhostaddr:9003\",
        \"fiatConversion\": false,
        \"unannouncedChannels\": false
      }
    }
  ]
}" > /tmp/RTL-Config.json 2>/dev/null
}