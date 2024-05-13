# Builds a container to run cryptography functions
# For btcrecover ... includes python3-tk
# All cpu cores from the host are available unless limited by a docker run command options: --cpus n, where n is a number

FROM debian:latest
RUN apt-get update -y && apt-get upgrade -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
               sudo vim nano libgmp-dev python3 python3-dev pip openssl \
               git python3-bitcoinlib python3-base58 \
               python3-tk build-essential libssl-dev\
        && apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN pip3 install bech32 --break-system-packages
RUN pip3 install base58 --break-system-packages
RUN pip install bip_utils --break-system-packages
#RUN pip3 install bitcoinlib --break-system-packages
#RUN pip3 install cryptography --break-system-packages
#RUN pip3 install pycryptodome --break-system-packages


#Make users and groups and directories
RUN groupadd -r parman && useradd -m -g parman -u 1000 parman 
RUN chown -R parman:parman /home/parman/
RUN usermod -aG sudo parman 
RUN echo 'parman:parmanode' | chpasswd

USER parman

RUN mkdir -p /home/parman/parman_programs/
WORKDIR /home/parman/parman_programs/
RUN git clone --depth 1 https://github.com/armantheparman/parmanode

WORKDIR /home/parman
RUN git clone --depth 1 https://github.com/3rdIteration/btcrecover.git
CMD tail -f /dev/null 
# Need to run fix_openssl_repemd160


#user should set number of cores to dedicate to docker container