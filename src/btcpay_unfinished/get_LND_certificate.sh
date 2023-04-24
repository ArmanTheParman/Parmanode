Get the LND's certificate fingerprint and paste it into the below config file.

openssl x509 -noout -fingerprint -sha256 -inform pem -in ~/.lnd/tls.cert