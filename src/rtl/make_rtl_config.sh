function make_rtl_config {

echo "  
{
  \"multiPass\": \"$rlt_password\",
  \"port\": \"3000\",
  \"defaultNodeIndex\": 1,
  \"dbDirectoryPath\": \"/home/$(whoami)/rtl_db\",
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
       \"macaroonPath\": \"/home/$(whoami)/.lnd/data/chain/bitcoin/mainnet\",
        \"configPath\": \"/home/$(whoami)/.lnd/lnd.conf\",
        \"swapMacaroonPath\": \"C:\\Users\\xyz\\AppData\\Local\\Loop\\mainnet\",
        \"boltzMacaroonPath\": \"C:\\Users\\xyz\\AppData\\Boltz\\mainnet\"
      },
      \"Settings\": {
        \"userPersona\": \"MERCHANT\",
        \"themeMode\": \"DAY\",
        \"themeColor\": \"PURPLE\",
        \"channelBackupPath\": \"C:\\Users\\xyz\\backup\\node-1\",
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