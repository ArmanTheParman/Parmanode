function make_rtl_config {

echo "  
{
  \"multiPass\": \"$rlt_password\",
  \"port\": \"3000\",
  \"defaultNodeIndex\": 1,
  \"dbDirectoryPath\": \"$HOME/parmanode/rtl\",
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
       \"macaroonPath\": \"$HOME/.lnd/data/chain/bitcoin/mainnet\",
        \"configPath\": \"$HOME/.lnd/lnd.conf\",
        \"swapMacaroonPath\": \"\",
        \"boltzMacaroonPath\": \"\"
      },
      \"Settings\": {
        \"userPersona\": \"MERCHANT\",
        \"themeMode\": \"DAY\",
        \"themeColor\": \"PURPLE\",
        \"channelBackupPath\": \"\",
        \"logLevel\": \"ERROR\",
        \"lnServerUrl\": \"https://127.0.0.1:8080\",
        \"swapServerUrl\": \"https://127.0.0.1:8081\",
          \"boltzServerUrl\": \"https://127.0.0.1:9003\",
        \"fiatConversion\": false,
        \"unannouncedChannels\": false
      }
    }
  ]
}" > ${original_dir}/src/rtl/RTL-Config.json 2>/dev/null
}