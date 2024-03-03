function copy_thub_env {
echo -e "# Info : https://docs.thunderhub.io/setup

# -----------
# Server Configs
# -----------

# LOG_LEVEL = 'error' | 'warn' | 'info' | 'http' | 'verbose' | 'debug' | 'silly' # Default: 'info'
# LOG_LEVEL='info'
# Can change loging output type:
# LOG_JSON=true
# Can make everything go through tor:
# TOR_PROXY_SERVER=socks://127.0.0.1:9050
# DISABLE_TWOFA=true

# -----------
# URLs
# -----------
MEMPOOL_URL='https://mempool.space'

# -----------
# Interface Configs
# -----------

# THEME = 'dark' | 'light' | 'night' # Default: 'dark'
# # # # # # # # # CURRENCY = 'sat' | 'btc' | 'fiat' # Default: 'sat'
THEME='dark'
CURRENCY='sat'

# -----------
# Subscription Configs
# -----------
# DISABLE_ALL_SUBS=true
# DISABLE_INVOICE_SUB=true
# DISABLE_PAYMENT_SUB=true
# DISABLE_FORWARD_SUB=true
# DISABLE_FORWARD_REQUESTS_SUB=true
# DISABLE_CHANNEL_SUB=true
# DISABLE_BACKUP_SUB=true

# -----------
# Privacy Configs
# -----------
# Prices and Fees ThunderHub fetches fiat prices from Blockchain.com api, and bitcoin
# on chain fees from Earn.com's api.
# LnMarkets ThunderHub can connect to the LnMarkets API. 
# ThunderHub shows you links for quick viewing of nodes by public key on 1ml.com, 
# and for viewing onchain transactions on Blockchain.com.
# Defaults are true, true, false, false, false

# FETCH_PRICES=false
# FETCH_FEES=false
# DISABLE_LINKS=true
# DISABLE_LNMARKETS=true
NO_VERSION_CHECK=true

# -----------
# Account Configs
# -----------
ACCOUNT_CONFIG_PATH='$hp/thunderhub/account_1.yaml'
MASTER_PASSWORD_OVERRIDE='password'
# YML_ENV_1=''
# YML_ENV_2=''
# YML_ENV_3=''
# YML_ENV_4=''

# -----------
# SSO Account Configs
# -----------
# If using cookie auth, need to access like this:
# http://localhost:3000/sso?token=[COOKIE], and put cookie contents in square brackets. 
# Useful for public (non local network) configurations.
# Otherwise, omit cookie, and enable Dangerous_no_sso_auth=true
# COOKIE_PATH='/path/to/cookie/.cookie'
SSO_SERVER_URL='127.0.0.1:10009'
SSO_CERT_PATH='/path/to/certificate/tls.cert'
SSO_MACAROON_PATH='/path/to/folder/containing/macaroons'
DANGEROUS_NO_SSO_AUTH=true
# LOGOUT_URL='http://thunderhub.io'

# -----------
# SSL Config
# -----------
# PUBLIC_URL='app.example.com'
SSL_PORT=2900
# SSL_SAVE=true
" | tee $file >/dev/null 2>&1
}
