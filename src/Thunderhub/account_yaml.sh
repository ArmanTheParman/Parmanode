#Account template
masterPassword: 'password' # Default password unless defined in account
accounts:
  - name: 'Account 1'
    serverUrl: 'url:port'
    macaroonPath: '/path/to/admin.macaroon'
    certificatePath: '/path/to/tls.cert'
    password: 'password for account 1'
  - name: 'Account 2'
    serverUrl: 'url:port'
    macaroonPath: '/path/to/admin.macaroon'
    certificatePath: '/path/to/tls.cert'
    # password: Leave without password and it will use the master password
  - name: 'Account 3'
    serverUrl: 'url:port'
    macaroon: '0201056...' # HEX or Base64 encoded macaroon
    certificate: '0202045c...' # HEX or Base64 encoded certificate
    password: 'password for account 3'