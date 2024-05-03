#Builds a container to run cryptography functions

FROM debian:latest
RUN apt-get update -y
RUN apt-get install -y vim nano libgmp-dev python3 pip openssl git python3-bitcoinlib python3-base58
RUN pip3 install bech32 --break-system-packages
RUN pip3 install base58 --break-system-packages
RUN pip3 install bip_utils --break-system-packages
RUN pip3 install bitcoinlib --break-system-packages
RUN pip3 install cryptography --break-system-packages
RUN pip3 install pycryptodome --break-system-packages
RUN pip3 install base58 --break-system-packages

#Make users and groups and directories
RUN groupadd -r parman && useradd -m -g parman -u 1000 parman 
RUN chown -R parman:parman /home/parman/
RUN echo 'parman:parmanode' | chpasswd

USER parman

RUN mkdir -p /home/parman/parman_programs/
WORKDIR /home/parman/parman_programs/
RUN git clone --depth 1 https://github.com/armantheparman/parmanode
RUN . ./parmanode/source_parmanode.sh
RUN . /home/parman/parman_programs/parmanode/src/ParmaWallet/fix_openssl_ripemd160.sh 
RUN fix_openssl_repemd160

WORKDIR /home/parman
RUN git clone --depth 1 https://github.com/3rdIteration/btcrecover.git
CMD tail -f /dev/null 


#user should set number of cores to dedicate to docker container