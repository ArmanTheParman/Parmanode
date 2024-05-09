#https://docs.thunderhub.io/setup#server-accounts

function make_thunderhub_account {

#cert=$(xxd -p -c 256 $HOME/.lnd/tls.cert | tr -d '\n')
#macaroon=$(xxd -p -c 256 $HOME/.lnd/data/chain/bitcoin/mainnet/admin.macaroon | tr -d '\n')
echo -e "
masterPassword: $password
accounts: 
  - name: Parmanode LND Account 1
    serverUrl: $LNDIP:$lnd_rpc_port
    macaroonPath: /home/parman/.lnd/data/chain/bitcoin/mainnet/admin.macaroon
    certificatePath: /home/parman/.lnd/tls.cert
" | tee $hp/thunderhub/account_1.yaml >/dev/null 2>&1
sudo chown 0:0 $hp/thunderhub/account_1.yaml
}

## Account template

# masterPassword: 'password' # Default password unless defined in account
# accounts:
#   - name: 'Account 1'
#     serverUrl: 'url:port'
#     macaroonPath: '/path/to/admin.macaroon'
#     certificatePath: '/path/to/tls.cert'
#     password: 'password for account 1'
#   - name: 'Account 2'
#     serverUrl: 'url:port'
#     macaroonPath: '/path/to/admin.macaroon'
#     certificatePath: '/path/to/tls.cert'
#     # password: Leave without password and it will use the master password
#     # if useing AES encryption of macaroon, must let TH know.
#     encrypted: true
#   - name: 'Account 3'
#     serverUrl: 'url:port'
#     macaroon: '0201056...' # HEX or Base64 encoded macaroon
#     certificate: '0202045c...' # HEX or Base64 encoded certificate
#     password: 'password for account 3'


# Notice you can specify either macaroonPath and certificatePath or macaroon and certificate.
# Note that the port in serverUrl should be the gRPC port that LND is listening on. (Typically 10009)

# On the first start of the server, the masterPassword and all account password fields will be 
# hashed and the file will be overwritten with these new values to avoid having cleartext 
# passwords on the server.