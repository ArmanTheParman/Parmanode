FROM node:latest

RUN apt-get update
RUN apt-get install -y wget gnupg sudo procps vim nano systemd curl git expect

RUN groupadd -r parman && useradd -m -g parman -u 1001 parman 
RUN chown -R parman:parman /home/parman/
RUN echo 'parman:parmanode' | chpasswd
RUN usermod -aG sudo parman

USER parman

RUN mkdir -p /home/parman/parmanode
RUN mkdir -p /home/parman/Downloads
RUN mkdir -p /media /mnt /tmp

WORKDIR /home/parman/parmanode
RUN git clone --depth 1 https://github.com/janoside/btc-rpc-explorer.git

USER root
WORKDIR /home/parman/parmanode/btc-rpc-explorer
RUN npm install -g btc-rpc-explorer

RUN cat > ./.env << 'EOF'
BTCEXP_SLOW_DEVICE_MODE=false
# BTCEXP_BITCOIND_USER=$rpcuser
# BTCEXP_BITCOIND_PASS=$rpcpassword
# BTCEXP_BITCOIND_RPC_TIMEOUT=50000
# BTCEXP=0.0.0.0
# BTCEXP_ADDRESS_API=electrumx
# BTCEXP_ELECTRUMX_SERVERS=$eserver
# BTCEXP_NO_RATES=false
EOF


CMD tail -f /dev/null