FROM node:20

#Default arguments: (if --build-arg missing)

RUN apt-get update
RUN apt-get install -y sudo vim git build-essential make cmake pkg-config libtool autoconf automake 
RUN groupadd -r parman && useradd -m -g parman parman 
RUN chown -R parman:parman /home/parman/
RUN echo 'parman:parmanode' | chpasswd
RUN usermod -aG sudo parman

USER parman

RUN mkdir -p /home/parman/parmanode/bre
RUN mkdir -p /home/parman/Downloads
RUN mkdir -p /media /mnt /tmp

WORKDIR /home/parman/parmanode
RUN git clone --depth 1 https://github.com/janoside/btc-rpc-explorer.git

#Make config file, move later to volume mount at ./bre, otherwise files get deleted
#Settings can be changed later in script depending of machine/OS
RUN echo "BTCEXP_SLOW_DEVICE_MODE=false"                     > /home/parman/parmanode/.env
RUN echo "BTCEXP_HOST=0.0.0.0"                              >> /home/parman/parmanode/.env
#RUN echo "BTCEXP_PORT=3002"                                >> /home/parman/parmanode/.env
RUN echo "BTCEXP_BITCOIND_HOST=host.docker.internal"        >> /home/parman/parmanode/.env
RUN echo "BTCEXP_BITCOIND_PORT=8332"                        >> /home/parman/parmanode/.env
RUN echo "BTCEXP_BITCOIND_USER=parman"                      >> /home/parman/parmanode/.env 
RUN echo "BTCEXP_BITCOIND_PASS=hodl"                        >> /home/parman/parmanode/.env  
RUN echo "BTCEXP_BITCOIND_RPC_TIMEOUT=50000"                >> /home/parman/parmanode/.env 
RUN echo "BTCEXP=0.0.0.0"                                   >> /home/parman/parmanode/.env 
RUN echo "BTCEXP_ADDRESS_API=electrumx"                     >> /home/parman/parmanode/.env
RUN echo "BTCEXP_ELECTRUM_SERVERS=tcp://host.docker.internal:50001"    >> /home/parman/parmanode/.env 
RUN echo "BTCEXP_ELECTRUM_SERVERS=tcp://host.docker.internal:50005"    >> /home/parman/parmanode/.env 
RUN echo "BTCEXP_NO_RATES=false"                            >> /home/parman/parmanode/.env 


WORKDIR /home/parman/parmanode/btc-rpc-explorer
CMD tail -f /dev/null