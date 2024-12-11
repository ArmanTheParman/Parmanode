# Variables can't be left in this file, they are all interpreted, then
# writting to the file
# Much of the text is from the sample service file from Bitcoin Core developers.

function make_bitcoind_service_file {
if [[ $btcpayinstallsbitcoin == "true" ]] ; then return 0 ; fi

echo "[Unit]
Description=Bitcoin daemon
After=network-online.target
Wants=network-online.target

[Service]
ExecStartPre=$HOME/.parmanode/mount_check.sh
ExecStart=/usr/local/bin/bitcoind -daemon \\
                            -pid=/run/bitcoind/bitcoind.pid \\
                            -conf=$HOME/.bitcoin/bitcoin.conf \\
                            -datadir=$HOME/.bitcoin

# Certifique-se de que o diretório de configuração pode ser lido pelo utilizador do serviço
PermissionsStartOnly=true

# Gestão de processos
####################

Type=forking
PIDFile=/run/bitcoind/bitcoind.pid
Restart=on-failure
TimeoutStartSec=infinity
TimeoutStopSec=600


User=$(whoami)
Group=$(id -ng)

RuntimeDirectory=bitcoind
RuntimeDirectoryMode=0710

# /etc/bitcoin
ConfigurationDirectory=bitcoin
ConfigurationDirectoryMode=0710

# /var/lib/bitcoind
StateDirectory=bitcoind
StateDirectoryMode=0710

# Medidas de reforço
####################

# Fornecer um /tmp e um /var/tmp privados.
PrivateTmp=true

# Monte /usr, /boot/ e /etc somente leitura para o processo.
ProtectSystem=full

# Não permite que o processo e todos os seus filhos 
# obtenham novos privilégios através de execve().
NoNewPrivileges=true

# Use um novo espaço de nome /dev preenchido apenas com 
# pseudo-dispositivos da API, como /dev/null, /dev/zero e /dev/random.
PrivateDevices=true

# Negar a criação de mapeamentos de memória graváveis e executáveis.
MemoryDenyWriteExecute=true

[Install]
WantedBy=multi-user.target
" | sudo tee /etc/systemd/system/bitcoind.service >$dn 

#tee used instead of echo because redirection operator after sudo echo loses sudo privilages

sudo systemctl daemon-reload 
sudo systemctl disable bitcoind.service >$dn 2>&1
sudo systemctl enable bitcoind.service >$dn 2>&1
}
