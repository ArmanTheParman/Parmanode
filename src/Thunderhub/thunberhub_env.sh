# Notice - If you use the .env template file and don't want it to be replaced after an update please duplicate and rename to .env.local
# https://docs.thunderhub.io/setup

# -----------
# Server Configs
# -----------
# LOG_LEVEL = 'error' | 'warn' | 'info' | 'http' | 'verbose' | 'debug' | 'silly' # Default: 'info'
LOG_LEVEL='info'
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
# Defaults are true, true, false, false, false
# FETCH_PRICES=false
# FETCH_FEES=false
# DISABLE_LINKS=true
# DISABLE_LNMARKETS=true
# NO_VERSION_CHECK=true

# -----------
# Account Configs
# -----------
ACCOUNT_CONFIG_PATH='/path/to/config/thubConfig.yaml'
MASTER_PASSWORD_OVERRIDE='secretPasswordForAllAccounts'
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
PUBLIC_URL='app.example.com'
SSL_PORT=8080
SSL_SAVE=true