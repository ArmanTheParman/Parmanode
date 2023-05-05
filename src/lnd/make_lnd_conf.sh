function make_lnd_conf {
source $HOME/.bitcoin/bitcoin.conf

echo " [Application Options]
tlsextraip=0.0.0.0
tlsextradomain=0.0.0.0
tlsautorefresh=true
adminmacaroonpath=~/.lnd/data/chain/bitcoin/mainnet/admin.macaroon
readonlymacaroonpath=~/.lnd/data/chain/bitcoin/mainnet/readonly.macaroon
invoicemacaroonpath=~/.lnd/data/chain/bitcoin/mainnet/invoice.macaroon
listen=0.0.0.0:9735
rpclisten=localhost:10009
restlisten=0.0.0.0:8080
restlisten=localhost:80
restlisten=localhost:443
maxpendingchannels=2
wallet-unlock-password-file=$HOME/.lnd/password.txt
wallet-unlock-allow-create=true
minchansize=200000
alias=$alias

[Bitcoin]
bitcoin.active=true
bitcoin.mainnet=true
bitcoin.node=bitcoind
bitcoin.defaultchanconfs=3
bitcoin.basefee=5000
bitcoin.feerate=50


[Bitcoind]
bitcoind.dir=~/.bitcoin
bitcoind.config=~/.bitcoin/bitcoin.conf
bitcoind.rpcuser=$rpcuser
bitcoind.rpcpass=$rpcuser
bitcoind.zmqpubrawblock=tcp://127.0.0.1:28332
bitcoind.zmqpubrawtx=tcp://127.0.0.1:28333


[autopilot]

[tor]
tor.streamisolation=true
tor.v3=true

[watchtower]

[wtclient]

[healthcheck]

[signrpc]

[walletrpc]

[chainrpc]

[routerrpc]

[workers]


[caches]

[protocol]

protocol.wumbo-channels=true

[db]

[etcd]

[postgres]


; Postgres connection string.
; db.postgres.dsn=postgres://lnd:lnd@localhost:45432/lnd?sslmode=disable

; Postgres connection timeout. Valid time units are {s, m, h}. Set to zero to
; disable.
; db.postgres.timeout=

; Postgres maximum number of connections. Set to zero for unlimited. It is
; recommended to set a limit that is below the server connection limit.
; Otherwise errors may occur in lnd under high-load conditions.
; db.postgres.maxconnections=

[bolt]

; If true, prevents the database from syncing its freelist to disk. 
; db.bolt.nofreelistsync=1

; Whether the databases used within lnd should automatically be compacted on
; every startup (and if the database has the configured minimum age). This is
; disabled by default because it requires additional disk space to be available
; during the compaction that is freed afterwards. In general compaction leads to
; smaller database files.
; db.bolt.auto-compact=true

; How long ago the last compaction of a database file must be for it to be
; considered for auto compaction again. Can be set to 0 to compact on every
; startup. (default: 168h)
; db.bolt.auto-compact-min-age=0

; Specify the timeout to be used when opening the database.
; db.bolt.dbtimeout=60s


[cluster]

[rpcmiddleware]

rpcmiddleware.enable=true

[remotesigner]

[gossip]

[invoices]

[routing]

[sweeper]
" | tee $HOME/.lnd/lnd.conf >/dev/null 2>&1

} 