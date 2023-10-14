FROM node:latest

#Default arguments: (if --build-arg missing)

RUN apt-get update
RUN apt-get install -y wget gnupg sudo procps vim nano systemd curl git expect

RUN groupadd -r parman && useradd -m -g parman -u 1001 parman 
RUN chown -R parman:parman /home/parman/
RUN echo 'parman:parmanode' | chpasswd
RUN usermod -aG sudo parman

USER parman

RUN mkdir -p /home/parman/parmanode/bre
RUN mkdir -p /home/parman/Downloads
RUN mkdir -p /media /mnt /tmp

WORKDIR /home/parman/parmanode
RUN git clone --depth 1 https://github.com/janoside/btc-rpc-explorer.git

WORKDIR /home/parman/parmanode/btc-rpc-explorer
RUN npm install -g btc-rpc-explorer

RUN echo "BTCEXP_SLOW_DEVICE_MODE=false"                     > /home/parman/parmanode/bre/.env
RUN echo "BTCEXP_HOST=127.0.0.1"                            >> /home/parman/parmanode/bre/.env
RUN echo "BTCEXP_BITCOIND_HOST=127.0.0.1"                   >> /home/parman/parmanode/bre/.env
RUN echo "BTCEXP_BITCOIND_PORT=8333"                        >> /home/parman/parmanode/bre/.env
RUN echo "BTCEXP_BITCOIND_USER=parman"                      >> /home/parman/parmanode/bre/.env 
RUN echo "BTCEXP_BITCOIND_PASS=hodl"                        >> /home/parman/parmanode/bre/.env  
RUN echo "BTCEXP_BITCOIND_RPC_TIMEOUT=50000"                >> /home/parman/parmanode/bre/.env 
RUN echo "BTCEXP=0.0.0.0"                                   >> /home/parman/parmanode/bre/.env 
RUN echo "BTCEXP_ADDRESS_API=electrumx"                     >> /home/parman/parmanode/bre/.env 
RUN echo "BTCEXP_ELECTRUM_SERVERS=tcp://127.0.0.1:50001"    >> /home/parman/parmanode/bre/.env 
RUN echo "BTCEXP_NO_RATES=false"                            >> /home/parman/parmanode/bre/.env 


CMD tail -f /dev/null